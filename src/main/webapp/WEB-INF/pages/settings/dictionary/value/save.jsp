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
			//获取字典类型编码内容
			queryAllDicTypeList();

			//保存按钮添加事件
			$("#saveCreateDicValueBtn").on("click",function () {
				//获取字典类型和字典值内容
				var dicTypeCode = $.trim($("#create-dicTypeCode").val());
				var dicValue = $.trim($("#create-dicValue").val());

				if (dicTypeCode == '' || dicValue == ''){
					alert("字典类型编码或字典值不可为空");
					return;
				}
				//获取文本和排序号的内容
				var createText =$.trim($("#create-text").val());
				var createOrderNo =$.trim($("#create-orderNo").val());
				//发送新增数据请求
				$.ajax({
					url:"settings/dictionary/value/saveCreateDicValue.do",
					type:"post",
					data:{
						typeCode:dicTypeCode,
						value:dicValue,
						text:createText,
						orderNo:createOrderNo
					},
					success:function (data) {
						if (data.code==1){
							window.location.href = "settings/dictionary/value/index.do"
						}else {
							alert(data.message)
						}
					}
				});
			});
		});
		//获取字典类型编码内容
	    function queryAllDicTypeList(){
			$.ajax({
				url:"settings/dictionary/type/queryAllDicTypeList.do",
				type:"get",
				success:function (list) {
					var str = "<option value=\"\">-----------请选择-----------</option>";
					$.each(list,function (index,obj) {
						str += "<option value=\""+obj.code+"\">"+obj.name+"</option>";
					})
					$("#create-dicTypeCode").html(str)
				}
			})
		}

	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveCreateDicValueBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">

		<div class="form-group">
			<label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-dicTypeCode" style="width: 200%;">
<%--					<option>-----------请选择-----------</option>--%>
<%--					<option value="sex">性别</option>--%>
<%--					<option value="appellation">称呼</option>--%>
<%--					<option value="stage">阶段</option>--%>
				</select>
			</div>
		</div>

		<div class="form-group">
			<label for="create-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-dicValue" style="width: 200%;">
			</div>
		</div>

		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-text" style="width: 200%;">
			</div>
		</div>

		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-orderNo" style="width: 200%;">
			</div>
		</div>
	</form>

	<div style="height: 200px;"></div>
</body>
</html>
