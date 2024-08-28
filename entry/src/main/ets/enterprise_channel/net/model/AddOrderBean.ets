export class AddOrderBodyBean {
  goldBeanNum: number
  constructor(goldBeanNum: number) {
    this.goldBeanNum = goldBeanNum;
  }
}

export class AddOrderBodyResultBean {
  orderId?: number
  orderNo?: string
  payAmount?: number
}

export class PreOrderBodyBean {
  orderId?: number
  paymentType?: number
  productType: number = 2
  constructor(orderId: number,paymentType: number) {
    this.orderId = orderId;
    this.paymentType = paymentType;
  }
}

export class PreOrderResultBean {
  orderId?: number
  orderNo?: string
  orderStr?: object
  paymentType?: number
}