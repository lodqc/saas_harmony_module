export class GoldBeanBuyDepositPackageBean {
  depositId?: number
  userId?: number
  packageId?: number
  constructor(depositId: number|undefined,packageId: number|undefined,  userId: number) {
    this.depositId = depositId;
    this.packageId = packageId;
    this.userId = userId;
  }
}

export class GoldBeanRecycleBean {
  depositOrderId?: number
  userId?: number
  packageOrderId?: number
  constructor(depositOrderId: number|undefined,packageOrderId: number|undefined,  userId: number) {
    this.depositOrderId = depositOrderId;
    this.packageOrderId = packageOrderId;
    this.userId = userId;
  }
}