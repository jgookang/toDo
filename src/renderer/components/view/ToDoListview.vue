<template>
  <div id="app">
    <ul class="todo-list list" v-if="viewType === 'list'">
        <li v-for="(item, index) in todos" :key=item.id
        v-bind:class="isDone(item.startDate) === 'Done' ?'Done':'Deadline'"
        v-show="item.filtered!=='y'"
        v-on:click="checkTodo(index)"/>
        <i class="far" v-bind:class="item.endDate? 'fa-check-square':'fa-square'"></i>
        <span class="title">{{item.title}}</span>
        <span class="start">
        <i v-for="n in Number(item.important)" :key=n class="fas fa-star"></i>
        </span>
    </ul>
  </div>
</template>

<script>
  import fs from 'fs'
  import path from 'path'
  const fileData = fs.readFileSync(path.join(__static, '/data/dummy.json'), 'utf8')
  const DUMMY_DATA = JSON.parse(fileData)
  export default {
    name: 'ToDoListview',
    data () {
      return {
        option: 'all',
        search: '',
        categories: [],
        todos: DUMMY_DATA,
        viewType: 'list',
        sortType: 'sort-numeric-up',
        buttons: {
          view: [
            { class: 'list', title: 'view in list', selected: true },
            { class: 'th-larg', title: 'view in thumbnail', selected: false }
          ],
          sort: [
            { class: 'sort-numeric-up', title: 'sort by deadlin', selected: true },
            { class: 'sort-alpahbet-down', title: 'sort by deadlin', selected: true },
            { class: 'start', title: 'sort by deadlin', selected: true }
          ]
        }
      }
    },
    method: {
      getDaydate: function (dateTime) {
        const pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/
        return dateTime.match(pattern)
      },
      getTime: function (dateTime) {
        const pattern = /^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/
        return dateTime.match(pattern)
      },
      formatDate: function (str) {
        const dealine = new Date(str)
        const today = this.getDaydate(new Date())
        const result = dealine === today ? 'today ' + this.getTime(dealine) : str
        return result
      },
      isDone: function (str) {
        const result = Date.parse(str) > Date.parse(new Date()) ? 'Done' : ''
        return result
      }
    }
  }
</script>
