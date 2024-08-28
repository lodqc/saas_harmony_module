export class PageBean<T> {
  content?: T[]
  limit?: number
  page?: number
  totalCount?: number
  totalPage?: number
}

export class HeaderBean {
  acceptEncoding?: string
  acceptLanguage?: string
  authorization?: string
  baseUrl?: string
  cacheControl?: string
  cityCode?: string
  userAgent?: string
}


