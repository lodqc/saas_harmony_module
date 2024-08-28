import { http } from '@kit.NetworkKit';
import { HeaderBean } from '@itcast/basic/src/main/ets/bean/NetBean';
export class RequestBean{
  url?: string
  method?: http.RequestMethod
  header?: HeaderBean
  body?: object|undefined
  constructor(url: string, method: http.RequestMethod, header: HeaderBean, body: object|undefined) {
    this.url = url;
    this.method = method;
    this.header = header;
    this.body = body;
  }
}