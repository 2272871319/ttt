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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function () {
			//更新按钮添加事件
			$("#saveEditDicValueBtn").on("click",function () {
				//获取字典值的内容
				var editValue = $("#edit-value").val()

				if (editValue == ""){
					alert("字典值不能为空哦")
				}
				//拿到所有框框的内容
				var editTypeCode = $("#edit-typeCode").val();
				var editValue = $("#edit-value").val();
				var editText = $("#edit-text").val();
				var editOrderNo = $("#edit-orderNo").val();
				var editId = $("#edit-id").val();
				//发送请求更新数据
				$.ajax({
					url:"settings/dictionary/value/saveEditDicValue.do",
					type:"post",
					data:{
						value:editValue,
						text:editText,
						orderNo:editOrderNo,
						typeCode:editTypeCode,
						id:editId
					},
					success:function (data) {
						if (data.code==1){
							window.location.href = "settings/dictionary/value/index.do"
						}else {
							alert(data.message)
						}
					}
				})
			})
		})
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveEditDicValueBtn" type="button" class="btn btn-primary">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
		<input type="hidden" id="edit-id" value="${dicValue.id}">
		<div class="form-group">
			<label for="edit-typeCode" class="col-sm-2 control-label">所属字典类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-typeCode" style="width: 200%;" value="${dicValue.typeCode}" readonly>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-value" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-value" style="width: 200%;" value="${dicValue.value}">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-text" style="width: 200%;" value="${dicValue.text}">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-orderNo" style="width: 200%;" value="${dicValue.orderNo}">
			</div>
		</div>
	</form>

	<div style="height: 200px;"></div>
</body>
</html>
