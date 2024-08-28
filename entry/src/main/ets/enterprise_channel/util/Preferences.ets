import dataPreferences from '@ohos.data.preferences';
const PREFERENCES_NAME = "top.wangchenyan.wanharmony"
const KEY_USER_INFO = "user_info";
const KEY_SEARCH_HISTORY = "search_history";
const KEY_SELECTED_TREE_ID_1 = "selected_tree_id_1";
const KEY_SELECTED_TREE_ID_2 = "selected_tree_id_2";

export default class Preferences {
  private static instance: Preferences;
  private preferences: dataPreferences.Preferences;

  private constructor(context: Context) {
    this.preferences = dataPreferences.getPreferencesSync(context, {
      name: PREFERENCES_NAME
    });
  }
  getSearchHistory(): string[] {
    return this.preferences.getSync(KEY_SEARCH_HISTORY, []) as string[];
  }

  putSearchHistory(historyKeys: string[]) {
    this.preferences.putSync(KEY_SEARCH_HISTORY, historyKeys)
    this.preferences.flush()
  }

  putSelectedTreeId(treeId1: number, treeId2: number) {
    this.preferences.putSync(KEY_SELECTED_TREE_ID_1, treeId1);
    this.preferences.putSync(KEY_SELECTED_TREE_ID_2, treeId2);
    this.preferences.flush()
  }

  static get(context: Context): Preferences {
    if (Preferences.instance === undefined) {
      Preferences.instance = new Preferences(context);
    }
    return Preferences.instance;
  }
}