<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script type="text/javascript">
		// $(document).ready(function(){
		// 	alert("-------------")
		// })

		$(function(){
			//获取字典类型列表发起请求
			queryAllDicTypeList();
			//创建按钮
			$("#createDicTypeBtn").on("click",function () {
				window.location.href="settings/dictionary/type/createDicTypeBtn.do"
			})

			//全选全不选
			$("#chkedAll").on("click",function () {
				$("#tBody input[type = 'checkbox']").prop("checked",$("#chkedAll").prop("checked"))
			})

			//反选
			$("#tBody").on("click","input[type = 'checkbox']",function () {
				// if ($("#tBody input[type = 'checkbox']:checked").size() == $("#tBody input[type = 'checkbox']").size() ){
				// 	$("#chkedAll").prop("checked",true)
				// }else {
				// 	$("#chkedAll").prop("checked",false)
				// }
				$("#chkedAll").prop("checked",$("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").length)
			})

			//编辑按钮
			$("#editDicTypeBtn").on("click",function () {
				//如果被选中的复选框不是一个
				var checkeds = $("#tBody input[type='checkbox']:checked");
				if (checkeds.length != 1){
					alert("请选择 1 条内容操作")
					return;
				}
				var code = checkeds.val();

				window.location.href = "settings/dictionary/type/editDicTypePage.do?code="+code;
			})

			//删除按钮添加事件
			$("#deleteDicTypeBtn").on("click",function () {
				var checkeds = $("#tBody input[type='checkbox']:checked")
				if (checkeds.length==0){
					alert("还没选择哦");
					return
				}
				if (confirm("确定要删除吗")){
					//获取要删除的标识
					var codes = "";
					$.each(checkeds,function (index,obj) {
						codes += "code="+$(obj).val()+"&";
					});
					codes=codes.substring(0,codes.length-1);

					$.ajax({
						url:"settings/dictionary/type/deleteDicType.do",
						type:"post",
						data:codes,
						success:function (data) {
							if (data.code==1){
								queryAllDicTypeList();
							}else {
								alert(data.message)
							}
						}
					})
				}


			})
		});

		//字典类型列表
		function queryAllDicTypeList() {
			$.ajax({
				url:"settings/dictionary/type/queryAllDicTypeList.do",
				date:"get",
				success:function (data) {
					//创建一个拼接的字符串
				    var htmlStr = "";
					//遍历返回的字典类型表DicType表的list集合
					$.each(data,function (index,obj) {
						if (index % 2 ==0){
							htmlStr += "<tr class=\"active\" id=\"\"+obj.code+\"\">";
						}else {
							htmlStr += "<tr>";
						}
						htmlStr += "<td><input type=\"checkbox\" value=\""+obj.code+"\"/></td>";
						htmlStr += "<td>"+(index+1)+"</td>";
						htmlStr += "<td>"+obj.code+"</td>";
						htmlStr += "<td>"+obj.name+"</td>";
						htmlStr += "<td>"+obj.description+"</td>";
						htmlStr += "</tr>";


					});
					$("#tBody").html(htmlStr);
				}
			})
		}

		//全选全不选

	</script>

</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button id="createDicTypeBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button id="editDicTypeBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button id="deleteDicTypeBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="chkedAll"/></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="tBody">
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>sex</td>
					<td>性别</td>
					<td>性别</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td>appellation</td>
					<td>称呼</td>
					<td>称呼</td>
				</tr>
			</tbody>
		</table>
	</div>

</body>
</html>
