export default class TimeUtils {
  static toYM(date: Date): string {
    // 或者，如果你想要一个特定的格式，比如 "YYYY-MM-DD"
    const year = date.getFullYear().toString().padStart(4, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 注意月份是从0开始的，所以需要+1
    // const day = date.getDate().toString().padStart(2, '0');
    const formattedDate = `${year}年${month}月`;
    return formattedDate;
	}
  static toYMD(timestamp: string): string {
    const date = new Date(timestamp);
    // 或者，如果你想要一个特定的格式，比如 "YYYY-MM-DD"
    const year = date.getFullYear().toString().padStart(4, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 注意月份是从0开始的，所以需要+1
    const day = date.getDate().toString().padStart(2, '0');
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    const seconds = date.getSeconds().toString().padStart(2, '0');
    const formattedDate = `${year}/${month}/${day}`;
    return formattedDate;
  }
  static toFull(timestamp: number): string {
    const date = new Date(timestamp);
    // 或者，如果你想要一个特定的格式，比如 "YYYY-MM-DD"
    const year = date.getFullYear().toString().padStart(4, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 注意月份是从0开始的，所以需要+1
    const day = date.getDate().toString().padStart(2, '0');
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    const seconds = date.getSeconds().toString().padStart(2, '0');
    const formattedDate = `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;
    return formattedDate;
  }
}