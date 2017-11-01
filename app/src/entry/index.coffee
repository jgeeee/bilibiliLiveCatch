import Vue from 'vue/dist/vue'
import IndexedDB from 'indexeddb-tools';
import '../style/index.sass'
import '../components/icon/style.sass'
import config from '../components/config.coffee'
import data from '../modules/index/data.coffee'
import methods from '../modules/index/methods.coffee'

# 初始化vue
app = new Vue({
  'el': '#vue-app',
  data,
  methods,
})

# 初始化数据库
{ name, version, objectStore } = config.indexeddb

initDbUp = (et, event)->
  { name, key, data } = objectStore.list
  if not @.hasObjectStore(name)
    @.createObjectStore(name, key, data)

initDbSuccess = (et, event)->
  _this = @
  store = @getObjectStore(objectStore.list.name)
  data2 = []
  store.cursor('name', (result, event)->
    if result
      data2.push(result.value)
      result.continue()
    else
      app.idList = data2
      app.tableLoading = false
      _this.close()
  )

IndexedDB(name, version, {
  'success': initDbSuccess,
  'upgradeneeded': initDbUp,
})