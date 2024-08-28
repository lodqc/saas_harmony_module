import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh';
import { EnterpriseChannelService } from '../../net/EnterpriseChannelService';
import { GetChannelUser } from '../../net/model/GetChannelUserBean';
import { toast } from '../../util/Toast';
import { LoadState, PageLoading } from '../../widget/PageLoading';
import { RiderItem } from './RiderItem';

@Preview
@Component
export struct RiderTab {
  searchType: number = 0;
  @Prop @Watch('onSearchKeyUpdated') searchKey: string = "";
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  @State data: GetChannelUser[] = [];
  private scroller: Scroller = new Scroller();
  private refreshConfig = new PullToRefreshConfigurator();
  private nextPage: number = 1;
  private hasMore: boolean = true;

  aboutToAppear() {
    this.loadData();
  }

  private loadData() {
    this.loadState = LoadState.LOADING
    this.loadDataByPage(0).then(
      (data) => {
        this.data = data;
        if (this.data.length === 0) {
          this.loadState = LoadState.EMPTY;
        } else {
          this.loadState = LoadState.SUCCESS;
        }
      },
      () => {
        this.loadState = LoadState.FAIL;
      })
  }

  private async loadDataByPage(page: number): Promise<GetChannelUser[]> {
    if (page == 0) {
      this.hasMore = true;
    }
    const res =
      await EnterpriseChannelService.getChannelUserList(this.searchType, page,
        this.searchType == 0 ? this.searchKey : undefined);
    return res.result?.content ? res.result.content : Promise.reject();
  }

  onSearchKeyUpdated(propName: string): void {
    this.loadData();
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
          PullToRefresh({
            data: this.data,
            scroller: this.scroller,
            refreshConfigurator: this.refreshConfig,
            customList: () => {
              this.listViewBuilder();
            },
            onRefresh: () => {
              return new Promise<string>((resolve) => {
                this.loadDataByPage(0).then(
                  (data) => {
                    this.nextPage = 1;
                    this.data = data;
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
                  this.loadDataByPage(this.nextPage).then(
                    (data) => {
                      if (data.length > 0) {
                        this.nextPage++
                        this.data = this.data.concat(data);
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
        .width('100%')
        .layoutWeight(1)
      }
    }.backgroundColor($r('app.color.bg1'))
  }

  @Builder
  private listViewBuilder() {
    List({ scroller: this.scroller }) {
      ForEach(this.data, (item: GetChannelUser) => {
        ListItem() {
          RiderItem({
            searchType: this.searchType, bean: item, onReload: () => {
              this.loadData();
            }
          })
        }
      })
    }
    .width('100%')
    .height('100%')
    .listDirection(Axis.Vertical)
    .divider({
      strokeWidth: 0.5,
      color: $r("app.color.divider"),
      startMargin: 16,
      endMargin: 16
    })
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }
}