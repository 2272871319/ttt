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


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		//当容器加载完成，对容器调用工具函数
		$(".mydate").datetimepicker({
			language:'zh-CN',//语言
			format:'yyyy-mm-dd',//日期格式
			minView:'month',//日期选择器上最小能选择的日期的视图
			initialDate:new Date(),// 日历的初始化显示日期，此处默认初始化当前系统时间
			autoclose:true,//选择日期之后，是否自动关闭日历
			todayBtn:true,//是否显示当前日期的按钮
			clearBtn:true,//是否显示清空按钮
		});
		//显示阶段的下拉框数据
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
				//显示阶段的下拉框数据
				$.ajax({
					url:"workbench/clue/convert/queryStageByDicValue.do",
					type:"get",
					success:function (data) {
						var str = "<option value=\"\">---请选择---</option>";
						$.each(data,function (index,list) {
							str += "<option value=\""+list.id+"\">"+list.value+"</option>";
						});
						$("#stage").html(str);
					}
				});
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//点击市场活动源后面的搜索放大镜
		$("#searchActivityBtn").on("click",function () {
			$("#searchActivityModal").modal("show")
		});

		//弹窗查询 关联市场活动按钮
		showConvert();
		//模糊查询搜索框添加键盘弹起事件
		$("#searchActivityText").on("keyup",function () {
			var searchActivityText = $("#searchActivityText").val();
			showConvert(searchActivityText);
		});

		//给转换按钮添加事件
		$("#convertBtn").on("click",function () {
			//拿到为客户创建交易的复选框的的状态
			var checkboxs = $("#isCreateTransaction").prop("checked");

			//拿到所有框框和需要的值
			var owner = "${clueSS.owner}";//所有者名称
			var money = $("#amountOfMoney").val();//金额
			var name = $("#tradeName").val();//名称
			var expectedDate = $("#expectedClosingDate").val();//预计成交时间
			var customerId = "${contacts.customerId}";
			var stage = $("#stage").val();//阶段
			var source = "${clueSS.source}";
			var activityId = $("#activityName").val();//市场活动
			var contactsId = "${contacts.id}";
			var description = "${clue.description}";//描述
			var contactSummary = "${clue.contactSummary}";//联系纪要
			var nextContactTime = "${clue.nextContactTime}";//下次联系时间

			$.ajax({
				url:"workbench/clue/convert/saveConvertByTran.do",
				type:"post",
				data:{
					owner:owner,
					money:money,
					name :name ,
					expectedDate:expectedDate,
					customerId:customerId,
					stage:stage,
					source:source,
					activityId:activityId,
					contactsId:contactsId,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime
				},
				success:function (data) {
					if (data.code == 1){
						alert("转化成功");
						$("#historyBack").click();
					}else {
						alert(data.message)
					}
				}
			})
		})
	});

	//弹窗查询 关联市场活动按钮
	function showConvert(searchActivityName) {

		var clueId = "${clue.id}";
		$.ajax({
			url:"workbench/clue/convert/showConvert.do",
			type:"get",
			data:{
				id:clueId,
				searchActivityName:searchActivityName
			},
			success:function (data) {
				var str = "";

				//显示数据
				$.each(data, function (index, list) {

					str += "<tr class=\"active\">";
					//str += "<td><input type=\"checkbox\" value='" + list.id + "'/></td>";
					str += "<td><input type=\"radio\" name=\"activity\" onclick=\"searchActivityModal('"+list.name+"','"+list.id+"')\" value='" + list.id + "'/></td>";
					str += "<td>" + list.name + "</td>";
					str += "<td>" + list.startDate + "</td>";
					str += "<td>" + list.endDate + "</td>";
					str += "<td>" + list.owner + "</td>";
					str += "</tr>";
				});
				$("#tBody").html(str);
			}
		})
	}

	function searchActivityModal(name,id) {
		$("#searchActivityModal").modal("hide");
		//为市场活动资源框赋值
		$("#activityName").val(name);
		$("#activityId").val(id);
	}
</script>

</head>
<body>

	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchActivityText" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullName}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullName}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control mydate" id="expectedClosingDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
		    	<c:forEach items="${stageList}" var="s">
					<option value="${s.id}">${s.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a id="searchActivityBtn" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    	<input type="hidden" id="activityId">
			  <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
		  </div>
		</form>

	</div>

	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="convertBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" id="historyBack" onclick="history.back()" type="button" value="取消">
	</div>
</body>
</html>
