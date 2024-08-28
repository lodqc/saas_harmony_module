import { PageBean } from '../../common/bean/NetBean'
import { hdHttp } from '../../common/utils/request'
import { AccountCenterBean } from './model/AccountCenterBean'
import { AddOrderBodyBean, AddOrderBodyResultBean, PreOrderBodyBean, PreOrderResultBean } from './model/AddOrderBean'
import { GetChannelDepositBean } from './model/GetChannelDepositBean'
import { GetChannelPackageBean } from './model/getChannelPackageBean'
import { GetChannelUser } from './model/GetChannelUserBean'
import { GoldBeanBuyDepositPackageBean, GoldBeanRecycleBean } from './model/GoldBeanBuyDepositPackageBean'
import { QueryRecordListBean } from './model/QueryRecordListBean'
import { QueryTradeLogListBean } from './model/QueryTradeLogListBean'

export class EnterpriseChannelService {
  static getChannelUserList(searchType: number, pageIndex: number, userPhone: string | undefined) {
    let url =
      `/cloud_manage/managerChannel/getChannelUserList?pageIndex=${pageIndex}&pageSize=15&searchType=${searchType}`
    if (userPhone) {
      url += `&userPhone=${userPhone}`
    }
    return hdHttp.get<PageBean<GetChannelUser>>(url)
  }

  static queryTradeLogList(pageIndex: number, date: Date) {
    const year = date.getFullYear().toString().padStart(4, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 注意月份是从0开始的，所以需要+1
    const beginDate = new Date(`${year}-${month}`).getTime()
    const endMonth = (date.getMonth() + 2).toString().padStart(2, '0'); // 注意月份是从0开始的，所以需要+1
    const endDate = new Date(`${year}-${endMonth}`)
    endDate.setDate(0)
    let url =
      `/cloud_manage/goldBean/app/queryTradeLogList?pageIndex=${pageIndex}&pageSize=15&beginDate=${beginDate}&endDate=${endDate.getTime()}`
    return hdHttp.get<PageBean<QueryTradeLogListBean>>(url)
  }

  static queryRecordList(pageIndex: number, date: Date) {
    const year = date.getFullYear().toString().padStart(4, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 注意月份是从0开始的，所以需要+1
    const beginDate = new Date(`${year}-${month}`).getTime()
    const endMonth = (date.getMonth() + 2).toString().padStart(2, '0'); // 注意月份是从0开始的，所以需要+1
    const endDate = new Date(`${year}-${endMonth}`)
    endDate.setDate(0)
    let url =
      `/cloud_manage/goldBean/app/queryRecordList?pageIndex=${pageIndex}&pageSize=15&beginDate=${beginDate}&endDate=${endDate.getTime()}`
    return hdHttp.get<PageBean<QueryRecordListBean>>(url)
  }

  static getChannelDepositList() {
    return hdHttp.get<GetChannelDepositBean[]>(`/cloud_manage/managerChannel/getChannelDepositList`)
  }

  static accountCenter() {
    return hdHttp.get<AccountCenterBean>(`/cloud_manage/goldBean/accountCenter`)
  }

  static getChannelPackageList() {
    return hdHttp.get<GetChannelPackageBean[]>(`/cloud_manage/managerChannel/getChannelPackageList`)
  }

  static goldBeanBuyDeposit(depositId: number, userId: number) {
    return hdHttp.post<object>(`/cloud_manage/goldBean/goldBeanBuyDeposit`,
      new GoldBeanBuyDepositPackageBean(depositId, undefined, userId))
  }

  static goldBeanBuyPackage(packageId: number, userId: number) {
    return hdHttp.post<object>(`/cloud_manage/goldBean/goldBeanBuyPackage`,
      new GoldBeanBuyDepositPackageBean(undefined, packageId, userId))
  }

  static goldBeanRecycle(depositOrderId: number, packageOrderId: number, userId: number) {
    return hdHttp.post<object>(`/cloud_manage/goldBean/goldBeanRecycle`,
      new GoldBeanRecycleBean(depositOrderId, packageOrderId, userId))
  }

  static addOrder(goldBeanNum: number) {
    return hdHttp.post<AddOrderBodyResultBean>(`/cloud_manage/goldBean/addOrder`, new AddOrderBodyBean(goldBeanNum))
  }

  static preOrder(orderId: number, paymentType: number) {
    return hdHttp.post<PreOrderResultBean>(`/cloud_manage/goldBean/preOrder`,
      new PreOrderBodyBean(orderId, paymentType))
  }

  static queryPayResult(orderId: number, payType: number) {
    return hdHttp.get<object>(`/cloud_manage/goldBean/queryPayResult?orderId=${orderId}&payType=${payType}`)
  }
}