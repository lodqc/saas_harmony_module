import { http } from '@kit.NetworkKit';
import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@ohos.base';
import { logger } from './logger';
import { HeaderBean } from '../bean/NetBean';

type HdParams = Record<string, string | number | boolean>

export interface HdResponse<T> {
  code: number
  msg: string
  result?: T
}

class HdHttp {
  headerStr = ""
  headerBean = new HeaderBean()

  private request<T>(path: string, method: http.RequestMethod = http.RequestMethod.GET, extraData?: Object) {
    if (this.headerStr == "") {
      this.headerStr  = AppStorage.get<string>('HeaderBean')??"{}"
      this.headerBean  = JSON.parse(this.headerStr);
    }
    const httpInstance = http.createHttp()

    const options: http.HttpRequestOptions = {
      header: {
        'Content-Type': 'application/json'
      },
      method,
      expectDataType: http.HttpDataType.OBJECT
    }

    let fullUrl = this.headerBean.baseUrl + path

    if (method === http.RequestMethod.GET && extraData) {
      const strArr = Object.keys(extraData)
        .filter(key => (extraData as HdParams)[key] !== undefined)
        .map(key => `${key}=${(extraData as HdParams)[key]}`)
      fullUrl += `?${strArr.join('&')}`
    } else {
      options.extraData = extraData
    }

    if (options.header) {
      options.header = {
        'Content-Type': 'application/json',
        'Accept-Language': this.headerBean.acceptLanguage,
        'Accept-Encoding': this.headerBean.acceptEncoding,
        'Cache-Control': this.headerBean.cacheControl,
        'User-Agent': this.headerBean.userAgent,
        'CityCode': this.headerBean.cityCode,
        'Authorization': this.headerBean.authorization,
      }
    }

    return httpInstance.request(fullUrl, options).then((res) => {
      if (res.result) {
        const result = res.result as HdResponse<T>
        if (result.code === 600) {
          logger.info(fullUrl, JSON.stringify(res.result).substring(0, 200))
          return result
        }else {
          promptAction.showToast({ message: result.msg || '网络错误' })
        }
      }
      return Promise.reject(res.result)
    }).catch((err: BusinessError) => {
      logger.error(fullUrl, err.code?.toString(), err.message)
      promptAction.showToast({ message: err.message || '网络错误' })
      return Promise.reject(err)
    }).finally(() => {
      httpInstance.destroy()
    })
  }

  // 网络抓包
  upsert(request: string, response: string) {
    AppStorage.setOrCreate("NetInfo", `${request}_${response}`)
  }

  get<T>(url: string, data?: Object): Promise<HdResponse<T>> {
    return this.request<T>(url, http.RequestMethod.GET, data)
  }

  post<T>(url: string, data?: Object): Promise<HdResponse<T>> {
    return this.request<T>(url, http.RequestMethod.POST, data)
  }

  put<T>(url: string, data?: Object): Promise<HdResponse<T>> {
    return this.request<T>(url, http.RequestMethod.PUT, data)
  }

  delete<T>(url: string, data?: Object): Promise<HdResponse<T>> {
    return this.request<T>(url, http.RequestMethod.DELETE, data)
  }
}


export const hdHttp = new HdHttp()