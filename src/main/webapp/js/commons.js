$(function () {
  //全选全不选
  $("#checkedAll").on("click",function () {
    $("#tBody input[type = 'checkbox']").prop("checked",$("#checkedAll").prop("checked"))
  })

//反选
  $("#tBody").on("click","input[type = 'checkbox']",function () {
    // if ($("#tBody input[type = 'checkbox']:checked").size() == $("#tBody input[type = 'checkbox']").size() ){
    // 	$("#checkedAll").prop("checked",true)
    // }else {
    // 	$("#checkedAll").prop("checked",false)
    // }
    $("#checkedAll").prop("checked",$("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").length)
  })
})
