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
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<!--  PAGINATION plugin -->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

	<script type="text/javascript" src="js/commons.js"></script>
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

		//查询线索来源和线索状态
		queryAllDicValueSourceAndState();
		//多条件分页查询
		queryAllByTermClueList(1,2);
		//查询按钮添加事件
		$("#queryTrim").on("click",function () {
			queryAllByTermClueList(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
		});

		//创建按钮添加事件
		$("#createClueBtn").on("click",function () {
			//显示创建页面
			$("#createClueModal").modal("show");

			$.ajax({
				url:"workbench/clue/createClue.do",
				type:"get",
				success:function (data) {
					//所有者下拉框
					var userStr = "<option value=\"\">---请选择---</option>";
					$.each(data.userList,function (index,user) {
						userStr += "<option value=\""+user.id+"\">"+user.name+"</option>";
					});
					$("#create-clueOwner").html(userStr);

					//称呼下拉框
					var appStr = "<option value=\"\">---请选择---</option>";
					$.each(data.appellationList,function (index,app) {
						appStr += "<option value=\""+app.id+"\">"+app.value+"</option>";
					});

					$("#create-appellation").html(appStr)
					//线索来源下拉框
					var sourceStr = "<option value=\"\">---请选择---</option>";
					$.each(data.sourceList,function (index,sour) {
						sourceStr += "<option value=\""+sour.id+"\">"+sour.value+"</option>";
					});
					$("#create-source").html(sourceStr);
					//线索状态下拉框
					var stateStr = "<option value=\"\">---请选择---</option>";
					$.each(data.clueStateList,function (index,stat) {
						stateStr += "<option value=\""+stat.id+"\">"+stat.value+"</option>";
					});
					$("#create-state").html(stateStr);
				}
			})
		});
		//创建中的保存按钮添加事件
		$("#saveCreateClueBtn").on("click",function () {
			//拿到三个必选框的值
			var owner = $("#create-clueOwner").val();
			var company = $("#create-company").val();
			var fullName = $("#create-fullName").val();

			//判断三个框值是否为空
			if (owner == ''){
				$("#clueOwnerMag").html("所有者不得为空");
				return;
			}
			if (company == ''){
				$("#companyMag").html("公司不得为空");
				return;
			}else {
				$("#companyMag").html("");
			}
			if (fullName == ''){
				$("#fullNameMag").html("姓名不得为空");
				return;
			}else {
				$("#fullNameMag").html("");
			};

			//拿到所有框的内容
			var appellation = $("#create-appellation").val();
			var job = $("#create-job").val();
			var email = $("#create-email").val();
			var website = $("#create-website").val();
			var phone = $("#create-phone").val();
			var mphone = $("#create-mphone").val();
			var state = $("#create-state").val();
			var source = $("#create-source").val();
			var description = $("#create-description").val();
			var contactSummary = $("#create-contactSummary").val();
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $("#create-address").val();

			$.ajax({
				url:"workbench/clue/saveCreateClue.do",
				type:"post",
				data:{
					owner:owner,
					company:company,
					fullName:fullName,
					appellation:appellation,
					job:job,
					email:email,
					website:website,
					phone:phone,
					mphone:mphone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				success:function (data) {
					if (data.code == 1){
						alert("添加成功")
						$("#createClueModal").modal("hide");
						queryAllByTermClueList($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
					}else {
						alert(data.message)
					}
				}
			});

		});

		//修改按钮添加事件
		$("#editClueBtn").on("click",function () {
			//拿到被选中的信息
			var checkboxs = $("#tBody input[type=checkbox]:checked");
			if(checkboxs.length != 1){
				alert("请选择 1 条信息编辑");
				return;
			}
			$("#editClueModal").modal("show");
			var id = checkboxs.val();
			//发送请求反显要修改的数据
			$.ajax({
				url:"workbench/clue/editClue.do",
				type:"post",
				data:{
					id:id
				},
				success:function (data) {
					//所有者下拉框
					var userStr = "";
					$.each(data.userList,function (index,user) {
						userStr += "<option value=\""+user.id+"\">"+user.name+"</option>";
					});
					$("#edit-clueOwner").html(userStr);
					$("#edit-clueOwner").val(data.clue.owner)

					//称呼下拉框
					var appStr = "<option value=\"\">---请选择---</option>";
					$.each(data.appellationList,function (index,app) {
						appStr += "<option value=\""+app.id+"\">"+app.value+"</option>";
					});
					$("#edit-call").html(appStr);
					$("#edit-call").val(data.clue.appellation);

					//线索来源下拉框
					var sourceStr = "<option value=\"\">---请选择---</option>";
					$.each(data.sourceList,function (index,sour) {
						sourceStr += "<option value=\""+sour.id+"\">"+sour.value+"</option>";
					});
					$("#edit-source").html(sourceStr);
					$("#edit-source").val(data.clue.source);

					//线索状态下拉框
					var stateStr = "<option value=\"\">---请选择---</option>";
					$.each(data.clueStateList,function (index,stat) {
						stateStr += "<option value=\""+stat.id+"\">"+stat.value+"</option>";
					});
					$("#edit-status").html(stateStr);

					$("#edit-status").val(data.clue.state);
					$("#edit-id").val(data.clue.id);
					$("#edit-job").val(data.clue.job);
					$("#edit-surname").val(data.clue.fullName);
					$("#edit-company").val(data.clue.company);
					$("#edit-email").val(data.clue.email);
					$("#edit-website").val(data.clue.website);
					$("#edit-phone").val(data.clue.phone);
					$("#edit-mphone").val(data.clue.mphone);
					$("#edit-describe").val(data.clue.description);
					$("#edit-contactSummary").val(data.clue.contactSummary);
					$("#edit-nextContactTime").val(data.clue.nextContactTime);
					$("#edit-address").val(data.clue.address);

					// if (data.code==1){
					// 	alert("修改成功");
					// 	$("#editClueModal").modal("hide");
					// 	queryAllByTermClueList($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
					// }else {
					// 	alert(data.message);
					// }
				}
			})
		});
		//修改中的更新按钮
		$("#saveUpdateClueBtn").on("click",function () {

			//拿到三个必选框的值
			var owner = $("#edit-clueOwner").val();
			var company = $("#edit-company").val();
			var fullName = $("#edit-surname").val();
			//判断两个必选框是否为空
			if (company == ''){
				$("#companyMag").html("公司不得为空");
				return;
			}else {
				$("#companyMag").html("");
			}
			if (fullName == ''){
				$("#fullNameMag").html("姓名不得为空");
				return;
			}else {
				$("#fullNameMag").html("");
			};
			var id = $("#edit-id").val();
			var appellation = $("#edit-call").val();
			var job = $("#edit-job").val();
			var email = $("#edit-email").val();
			var website = $("#edit-website").val();
			var phone = $("#edit-phone").val();
			var mphone = $("#edit-mphone").val();
			var state = $("#edit-status").val();
			var source = $("#edit-source").val();
			var description = $("#edit-describe").val();
			var contactSummary = $("#edit-contactSummary").val();
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $("#edit-address").val();

			//发送请求保存数据
			$.ajax({
				url:"workbench/clue/saveUpdateClue.do",
				type:"post",
				data:{
					id:id,
					owner:owner,
					company:company,
					fullName:fullName,
					appellation:appellation,
					job:job,
					email:email,
					website:website,
					phone:phone,
					mphone:mphone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				success:function (data) {
					if (data.code == 1){
						alert("更新成功")
						$("#editClueModal").modal("hide");
						queryAllByTermClueList($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
					}else {
						alert(data.message)
					}
				}
			})
		});

		//删除按钮添加事件
		$("#deleteBtn").on("click",function () {
			//拿到所有被选框
			var checkboxs = $("#tBody input[type=checkbox]:checked");
			if (checkboxs.length == 0){
				alert("至少删除一条");
				return;
			}
			if (confirm("确定要删除吗")){
				var idsStr = "";
				$.each(checkboxs,function (index,obj) {
					idsStr += "id="+obj.value+"&";
				})
				idsStr = idsStr.substring(0,idsStr.length-1);

				$.ajax({
					url:"workbench/clue/deleteAll.do",
					type:"post",
					data: idsStr,
					success:function (data) {
						if (data.code == 1 ){
							alert("成功删除"+data.data+"条数据");
							queryAllByTermClueList(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
						}else {
							alert(data.message)
						}
					}
				})
			}
		})

	});
	//查询线索来源和线索状态
	function queryAllDicValueSourceAndState() {
		$.ajax({
			url:"workbench/clue/queryAllDicValueSourceAndState.do",
			type:"get",
			success:function (data) {
				var str = "<option value=\"\">"+"---请选择---"+"</option>";
				$.each(data.sourceList,function (index,obj) {
					str += "<option value=\""+obj.id+"\">"+obj.value+"</option>"
				});
				$("#source").html(str);

				var strState = "<option value=\"\">"+"---请选择---"+"</option>";
				$.each(data.clueStateList,function (index,obj) {
					strState += "<option value=\""+obj.id+"\">"+obj.value+"</option>"
				});

				$("#state").html(strState)
			}
		})
	}
	//多条件分页查询
	function queryAllByTermClueList(pageNo,pageSize) {
		$("#checkedAll").prop("checked",false);
		//获取所有查询框的值
		var fullName = $("#fullName").val();
		var company = $("#company").val();
		var phone = $("#phone").val();
		var source = $("#source").val();
		var owner = $("#owner").val();
		var mphone = $("#mphone").val();
		var state = $("#state").val();

		$.ajax({
			url:"workbench/clue/queryAllByTermClueList.do",
			type:"post",
			data:{
				fullName:fullName,
				company:company,
				phone:phone,
				source:source,
				owner:owner,
				mphone:mphone,
				state:state,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success:function (data) {
				var str = "";

				$.each(data.clueList,function (index,list) {
					str += "<tr>";
					str += "<td><input type=\"checkbox\" value='"+list.id+"'/></td>";
					str += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?id="+list.id+"'\">"+list.fullName+""+list.appellation+"</a></td>";
					str += "<td>"+list.company+"</td>";
					str += "<td>"+list.phone+"</td>";
					str += "<td>"+list.mphone+"</td>";
					str += "<td>"+list.source+"</td>";
					str += "<td>"+list.owner+"</td>";
					str += "<td>"+list.state+"</td>";
					str += "<tr>";
				});
				$("#tBody").html(str);

				$("#demo_pag1").bs_pagination({
					currentPage:pageNo,//当前页

					rowsPerPage:pageSize,//每页显示条数
					totalRows:data.totalRows,//总条数
					totalPages: data.totalPage,//总页数

					visiblePageLinks:3,//显示的翻页卡片数

					showGoToPage:true,//是否显示"跳转到第几页"
					showRowsPerPage:true,//是否显示"每页显示条数"
					showRowsInfo:true,//是否显示"记录的信息"

					//每次切换页号都会自动触发此函数，函数能够返回切换之后的页号和每页显示条数
					onChangePage: function(e,pageObj) { // returns page_num and rows_per_page after a link has clicked
						// alert(pageObj.currentPage);
						// alert(pageObj.rowsPerPage);
						queryAllByTermClueList(pageObj.currentPage,pageObj.rowsPerPage)
					}
				});
			}
		})

	}
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
								  <c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
								  </c:forEach>
								</select>
								<span id="clueOwnerMag" style="color: red"></span>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
								<span id="companyMag" style="color: red"></span>
							</div>
						</div>

						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellationList}" var="a">
										<option value="${a.id}">${a.value}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullName">
								<span id="fullNameMag" style="color: red"></span>
							</div>
						</div>

						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>

						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>

						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <c:forEach items="${clueStateList}" var="cs">
									  <option value="${cs.id}">${cs.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${sourceList}" var="s">
										<option value="${s.id}">${s.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>


						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateClueBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<input type="hidden" id="edit-id">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.id}">${a.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:forEach items="${clueStateList}" var="cs">
										<option value="${cs.id}">${cs.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="edit-nextContactTime" value="2017-05-01" readonly>
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveUpdateClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>




	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="fullName">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="company">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="phone">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="source">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <br>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="owner">
				    </div>
				  </div>



				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="mphone">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="state">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="cs">
							  <option value="${cs.id}">${cs.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryTrim">查询</button>
					<button type="reset" class="btn btn-default">重置</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkedAll"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detailClue.do'">张三先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detailClue.do'">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>
					</tbody>
				</table>
			</div>
			<br>
			<br>
			<br>
			<div id="demo_pag1">

			</div>



		</div>

	</div>
</body>
</html>
