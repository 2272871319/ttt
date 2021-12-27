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
<script type="text/javascript" src="js/commons.js"></script>
	<script type="text/javascript">
		$(function () {
			//查询全部字典值
			queryAllDicValueList();
			// //全选
			// $("#checkAll").on("click",function () {
			// 	$("#tBody input[type=checkbox]").prop("checked",$("#checkAll").prop("checked"))
			// });
			// //反选
			// $("#tBody").on("click","input[type=checkbox]",function () {
			//
			// 	$("#checkAll").prop("checked",$("#tBody input[type=checkbox]:checked").length == $("#tBody input[type=checkbox]").length)
			//
			// })
			//创建按钮添加事件
			$("#createDicValueBtn").on("click",function () {
				window.location.href = "settings/dictionary/value/createDicValue.do"
			})
			//编辑按钮添加事件
			$("#editDicValueBtn").on("click",function () {
				//获取被选中信息的数量
				var checkeds = $("#tBody input[type=checkbox]:checked")
				if (checkeds.length!=1){
					alert("请选中 1 条信息操作")
					return;
				}
				var id = checkeds.val()
				window.location.href = "settings/dictionary/value/editDicValue.do?id="+id
			})

			//删除按钮添加事件
			$("#deleteDicValueBtn").on("click",function () {

				//拿到被选中的框框
				var deletes = $("#tBody input[type=checkbox]:checked")
				if (deletes.length == 0) {
					alert("还没选中哦")
				}
				//关心一下
				if (confirm("确定删除吗")) {
					//拿到被选中框的值  就是主键ID
					var ids = "";
					$.each(deletes,function (index,obj) {
						// ids += "id="+$(obj).val()+"&";
						ids += "id="+obj.value+"&";
					});
					ids = ids.substring(0,ids.length-1);

					$.ajax({
						url: "settings/dictionary/value/deleteDicValueBtn.do",
						type: "post",
						data: ids,
						success: function (data) {
							if (data.code == 1) {
								alert("成功删除"+data.data+"条数据");
								window.location.href = "settings/dictionary/value/index.do"
							} else {
								alert(data.message)
							}
						}
					})
				}
			})
		});

		//查询全部字典值
		function queryAllDicValueList() {
			$.ajax({
				url:"settings/dictionary/value/queryAllDicValueList.do",
				type:"get",
				success:function (data) {
					var str = "";
					$.each(data,function (index,list) {
						str += "<tr class=\"active\">";
						str += "<td><input type=\"checkbox\" value=\""+list.id+"\"/></td>";
						str += "<td>"+(index+1)+"</td>";
						str += "<td>"+list.value+"</td>";
						str += "<td>"+list.text+"</td>";
						str += "<td>"+list.orderNo+"</td>";
						str += "<td>"+list.typeCode+"</td>";
						str += "</tr>";
					});
					$("#tBody").html(str)
				}
			})
		}
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button id="createDicValueBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button id="editDicValueBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button id="deleteDicValueBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color:cadetblue;">
					<td><input type="checkbox" id="checkedAll" /></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="tBody">
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>m</td>
					<td>男</td>
					<td>1</td>
					<td>sex</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td>f</td>
					<td>女</td>
					<td>2</td>
					<td>sex</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>3</td>
					<td>1</td>
					<td>一级部门</td>
					<td>1</td>
					<td>orgType</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>4</td>
					<td>2</td>
					<td>二级部门</td>
					<td>2</td>
					<td>orgType</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>5</td>
					<td>3</td>
					<td>三级部门</td>
					<td>3</td>
					<td>orgType</td>
				</tr>
			</tbody>
		</table>
	</div>

</body>
</html>
