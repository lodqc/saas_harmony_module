import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh';
import { EnterpriseChannelService } from '../../net/EnterpriseChannelService';
import { QueryRecordListBean } from '../../net/model/QueryRecordListBean';
import { QueryTradeLogListBean } from '../../net/model/QueryTradeLogListBean';
import { LoadState, PageLoading } from '../../widget/PageLoading';
import { QueryRecordListItem } from './QueryRecordListItem';
import { QueryTradeLogItem } from './QueryTradeLogItem';

@Component
export struct OperationalList {
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  @State tradeList: QueryTradeLogListBean[] = [];
  @State recordList: QueryRecordListBean[] = [];
  private scroller: Scroller = new Scroller();
  private refreshConfig = new PullToRefreshConfigurator();
  private nextPage: number = 1;
  private hasMore: boolean = true;
  @Prop @Watch('onBeginDate') selectedDate: Date = new Date();
  @Prop type: number;
  @Link disburseCount: number;
  @Link topUpCount: number;
  @Link giftCount: number;

  async aboutToAppear() {
    this.loadData();
  }

  onBeginDate(propName: string): void {
    this.loadData();
  }

  private loadData() {
    this.loadState = LoadState.LOADING
    if (this.type == 0) {
      this.loadData0(0).then(
        (data) => {
          this.tradeList = data;
          this.setCount()
          if (this.tradeList.length === 0) {
            this.loadState = LoadState.EMPTY;
          } else {
            this.loadState = LoadState.SUCCESS;
          }
        },
        () => {
          this.loadState = LoadState.FAIL;
        })
    }

    if (this.type == 1) {
      this.loadData1(0).then(
        (data) => {
          this.recordList = data;
          this.setCount()
          if (this.recordList.length === 0) {
            this.loadState = LoadState.EMPTY;
          } else {
            this.loadState = LoadState.SUCCESS;
          }
        },
        () => {
          this.loadState = LoadState.FAIL;
        })
    }
  }

  private async loadData0(page: number): Promise<QueryTradeLogListBean[]> {
    if (page == 0) {
      this.hasMore = true;
    }
    const res = await EnterpriseChannelService.queryTradeLogList(page, this.selectedDate);
    return res.result?.content ? Promise.resolve(res.result.content) : Promise.reject()
  }

  private async loadData1(page: number): Promise<QueryRecordListBean[]> {
    if (page == 0) {
      this.hasMore = true;
    }
    const res = await EnterpriseChannelService.queryRecordList(page, this.selectedDate);
    return res.result?.content ? Promise.resolve(res.result.content) : Promise.reject()
  }

  build() {
    Column() {
      PageLoading({
        loadState: this.loadState,
        showLoading: this.showLoading,
        onReload: () => {
          this.loadData();
        }
      }) {
        Column() {
          if (this.type == 0) {
            PullToRefresh({
              data: this.tradeList,
              scroller: this.scroller,
              refreshConfigurator: this.refreshConfig,
              customList: () => {
                this.listViewBuilder();
              },
              onRefresh: () => {
                return new Promise<string>((resolve) => {
                  this.loadData0(0).then(
                    (data) => {
                      this.nextPage = 1;
                      this.tradeList = data;
                      this.setCount()
                      resolve('刷新成功');
                    },
                    () => {
                      resolve('刷新失败');
                    }
                  )
                });
              },
              onLoadMore: () => {
                return new Promise<string>((resolve) => {
                  if (this.hasMore) {
                    this.loadData0(this.nextPage).then(
                      (data) => {
                        if (data.length > 0) {
                          this.nextPage++
                          this.tradeList = this.tradeList.concat(data);
                          this.setCount()
                          resolve('加载成功');
                        } else {
                          this.hasMore = false;
                          resolve('没有更多了');
                        }
                      },
                      () => {
                        resolve('加载失败');
                      }
                    )
                  } else {
                    resolve('没有更多了');
                  }
                });
              },
            })
          }

          if (this.type == 1) {
            PullToRefresh({
              data: this.recordList,
              scroller: this.scroller,
              refreshConfigurator: this.refreshConfig,
              customList: () => {
                this.listViewBuilder();
              },
              onRefresh: () => {
                return new Promise<string>((resolve) => {
                  this.loadData1(0).then(
                    (data) => {
                      this.nextPage = 1;
                      this.recordList = data;
                      this.setCount()
                      resolve('刷新成功');
                    },
                    () => {
                      resolve('刷新失败');
                    }
                  )
                });
              },
              onLoadMore: () => {
                return new Promise<string>((resolve) => {
                  if (this.hasMore) {
                    this.loadData1(this.nextPage).then(
                      (data) => {
                        if (data.length > 0) {
                          this.nextPage++
                          this.recordList = this.recordList.concat(data);
                          this.setCount()
                          resolve('加载成功');
                        } else {
                          this.hasMore = false;
                          resolve('没有更多了');
                        }
                      },
                      () => {
                        resolve('加载失败');
                      }
                    )
                  } else {
                    resolve('没有更多了');
                  }
                });
              },
            })
          }
        }
        .width('100%')
        .height('100%')
      }
    }
  }

  setCount() {
    if (this.type == 0) {
      this.disburseCount = 0
      this.tradeList.forEach((bean) => {
        if (bean.actionType == 1) {
          this.disburseCount += bean.tradeGoldBean ?? 0
        }
      })
    }

    if (this.type == 1) {
      this.giftCount = 0
      this.topUpCount = 0
      this.recordList.forEach((bean) => {
        if (bean.actionType == 1) {
          if (bean.tradeType == 4) {
            this.giftCount += bean.goldBeanNum ?? 0
          } else {
            this.topUpCount += bean.goldBeanNum ?? 0
          }
        }
      })
    }
  }

  @Builder
  private listViewBuilder() {
    List({ scroller: this.scroller }) {
      this.getItem()
    }
    .width("100%")
    .height('100%')
    .scrollBarWidth(0)
    .listDirection(Axis.Vertical)
    .divider({
      strokeWidth: 0.5,
      color: $r("app.color.divider"),
      startMargin: 16,
      endMargin: 16
    })
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }

  @Builder
  getItem() {
    if (this.type == 0) {
      ForEach(this.tradeList, (item: QueryTradeLogListBean) => {
        ListItem() {
          QueryTradeLogItem({ item: item });
        };
      })
    }

    if (this.type == 1) {
      ForEach(this.recordList, (item: QueryRecordListBean) => {
        ListItem() {
          QueryRecordListItem({ item: item });
        };
      })
    }
  }
}
