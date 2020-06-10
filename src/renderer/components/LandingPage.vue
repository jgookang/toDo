<template>
  <div id="app">
    <ToDoListview></ToDoListview>
  </div>
</template>

<script>
  import ToDoListview from './view/ToDoListview'
  export default {
    name: 'app',
    components: { ToDoListview }
  }
</script>

<style>
  @import url('https://fonts.googleapis.com/css?family=Source+Sans+Pro');

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  body { font-family: 'Source Sans Pro', sans-serif; }

</style>
