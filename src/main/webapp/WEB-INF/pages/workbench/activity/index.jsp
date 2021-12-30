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

		//多条件分页查询
        queryAllActivityList(1,4);
		//查询按钮添加事件
		$("#queryActivityBtn").on("click",function () {
			queryAllActivityList(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
		});

		//创建按钮添加事件
		$("#createActivityBtn").on("click",function () {
			//打开创建页面
			$("#createActivityModal").modal("show");
			//显示页面数据-导入全部所有者信息
			$.ajax({
				url:"workbench/activity/createActivityModal.do",
				type:"get",
				success:function (list) {
					var str = "<option value=\"\">----------请选择---------</option>";
					$.each(list,function (index,u) {
						str += "<option value="+u.id+">"+u.name+"</option>"
					})
					$("#create-marketActivityOwner").html(str);
				}
			})
		});

		//创建中的保存按钮添加事件
		$("#saveCreateActivityBtn").on("click",function () {
			//获取三个必填框的值
			var owner = $("#create-marketActivityOwner").val();
			var name = $("#create-marketActivityName").val();
			var cost = $("#create-cost").val();

			if(owner == ''){
				$("#ownerMsg").html("所有者不能为空");
				return;
			}

			if(name == ""){
				$("#nameMsg").html("名称不能为空");
				return;
			}

			if(cost == ""){
				$("#costMsg").html("成本不能为空");
				return;
			}else if(!/^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(cost)){
				$("#costMsg").html("成本书写不合法");
				return;
			}
			//获取所有框的信息
			var startDate = $("#create-startDate").val();
			var endDate = $("#create-endDate").val();
			var description = $("#create-description").val();
			//发送请求保存数据
			$.ajax({
				url:"workbench/activity/saveCreateActivity.do",
				type:"post",
				data:{
					owner:owner,
					name:name,
					cost:cost,
					startDate:startDate,
					endDate:endDate,
					description:description
				},
				success:function (data) {
					if (data.code==1){
						$("#createActivityModal").modal("hide");
						queryAllActivityList(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
					}else {
						alert(data.message)
					}
				}
			})

		});

		//编辑按钮添加事件
		$("#editActivityBtn").on("click",function () {
			var checkboxs = $("#tBody input[type='checkbox']:checked");
			if(checkboxs.length !=1 ){
				alert("请选择 1 条信息编辑");
				return;
			}
			$("#editActivityModal").modal("show");

			var id = checkboxs.val();
			$.ajax({
				url:"workbench/activity/editActivityModal.do?id="+id,
				type:"get",
				success:function (data) {
					var str = "";
					$.each(data.userList,function (index,obj) {
						str += "<option value='"+obj.id+"'>"+obj.name+"</option>";
					});
					$("#edit-marketActivityOwner").html(str);

					$("#edit-marketActivityOwner").val(data.activity.owner);
					$("#edit-marketActivityName").val(data.activity.name);
					$("#edit-startDate").val(data.activity.startDate);
					$("#edit-endDate").val(data.activity.endDate);
					$("#edit-cost").val(data.activity.cost);
					$("#edit-description").val(data.activity.description);
					$("#edit-id").val(data.activity.id);
				}
			})
		});

		//编辑中的更新按钮添加事件
		$("#saveEditActivityBtn").on("click",function () {
			//获取所有者和名称的值
			var owner = $("#edit-marketActivityOwner").val();
			var name = $("#edit-marketActivityName").val();

			if (name == ''){
				$("#markeMsg").html("名称不能为空")
			}
			//获取开始结束成本描述的内容
			var startDate = $("#edit-startDate").val();
			var endDate = $("#edit-endDate").val();
			var cost = $("#edit-cost").val();
			var description = $("#edit-description").val();
			var id = $("#edit-id").val();

			$.ajax({
				url:"workbench/activity/saveEditActivity.do",
				type:"post",
				data:{
					id:id,
					owner:owner,
					name:name ,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				success:function (data) {
					if (data.code == 1){
						$("#editActivityModal").modal("hide");
						queryAllActivityList($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"))
					}else {
						alert(data.message);
					}
				}
			})
		});

		//删除按钮添加事件
		$("#deleteActivityBtn").on("click",function () {

				//获取被选中的按钮对象
				var checkboxs = $("#tBody input[type='checkbox']:checked");
				if (checkboxs.length == 0){
					alert("先选中再删除")
					return;
				}

			if (confirm("确定删除吗")){
				//拼接字符串
				var str = "";
				$.each(checkboxs,function (index,ids) {
					str+= "id="+ids.value+"&";
				});
				str = str.substring(0,str.length-1);
				//发送请求批量删除
				$.ajax({
					url:"workbench/activity/deleteActivity.do",
					type:"post",
					data:str,
					success:function (data) {
						if (data.code == 1){
							queryAllActivityList($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"))
							alert("成功删除"+data.data+"条数据");
						}else {
							alert(data.message)
						}
					}
				})
			}
		})

		//全部导出按钮添加事件
		$("#exportActivityAllBtn").on("click",function () {
			window.location.href = "workbench/activity/exportActivityAll.do";
		})
		//选择导出按钮添加shijian
		$("#exportActivityXzBtn").on("click",function () {

			var checkboxs = $("#tBody input[type='checkbox']:checked");

			if (checkboxs.length == 0){
				alert("还没选中哦");
				return;
			}

			var str = "";
			$.each(checkboxs,function (index,id) {
				str += "id="+id.value+"&";
			});
			str = str.substring(0,str.length-1);
			window.location.href = "workbench/activity/exportActivityXz.do?"+str;
		})

	});

	//多条件分页查询
	function queryAllActivityList(pageNo,pageSize) {

		$("#checkedAll").prop("checked",false);
		//获取页面信息
		var queryName = $.trim($("#query-name").val());
		var queryOwner = $.trim($("#query-owner").val());
		var queryStartDate = $.trim($("#query-startDate").val());
		var queryEndDate = $.trim($("#query-endDate").val());

		$.ajax({
			url:"workbench/activity/queryAllActivityList.do",
			type:"get",
			data:{
				activityName:queryName,
				ownerName:queryOwner,
				StartDate:queryStartDate,
				endDate:queryEndDate,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success:function (data) {
				var str = "";

				//显示数据
				$.each(data.activityList,function (index,list) {

					str += "<tr class=\"active\">";
				str += "<td><input type=\"checkbox\" value='"+list.id+"'/></td>";
				str += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detail.do?id="+list.id+"';\">"+list.name+"</a></td>";
				str += "<td>"+list.owner+"</td>";
				str += "<td>"+list.startDate+"</td>";
				str += "<td>"+list.endDate+"</td>";
				str += "</tr>";
				});

				$("#tBody").html(str);


				//分页模型
				$("#demo_pag1").bs_pagination({
					currentPage:pageNo,//当前页

					rowsPerPage:pageSize,//每页显示条数
					totalRows:data.totalRows,//总条数
					totalPages: data.totalPage,//总页数

					visiblePageLinks:2,//显示的翻页卡片数

					showGoToPage:true,//是否显示"跳转到第几页"
					showRowsPerPage:true,//是否显示"每页显示条数"
					showRowsInfo:true,//是否显示"记录的信息"

					//每次切换页号都会自动触发此函数，函数能够返回切换之后的页号和每页显示条数
					onChangePage: function(e,pageObj) { // returns page_num and rows_per_page after a link has clicked
						// alert(pageObj.currentPage);
						// alert(pageObj.rowsPerPage);
						queryAllActivityList(pageObj.currentPage,pageObj.rowsPerPage);
					}

				});
			}
		})
	}

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form" id="activityForm">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								</select>
								<span style="color: red" id="ownerMsg"></span>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
								<span style="color: red" id="nameMsg"></span>
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startDate" readonly="true">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endDate" readonly="true">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
								<span style="color: red" id="costMsg"></span>
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateActivityBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
					    <input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
								<span style="color: red" id="markeMsg"></span>
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startDate" value="2020-10-10" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endDate" value="2020-10-20" readonly>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditActivityBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls格式]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control mydate" type="text" id="query-startDate" readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control mydate" type="text" id="query-endDate" readonly>
				    </div>
				  </div>
					<br>
				  <button id="queryActivityBtn" type="button" class="btn btn-default">查询</button>
					<button type="reset" class="btn btn-default">清空</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createActivityBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteActivityBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button id="importActivityListBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（全部导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkedAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">加载中</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">加载中</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>
					</tbody>
				</table>
                <!--创建容器-->
                <div id="demo_pag1"></div>
			</div>


		</div>

	</div>
</body>
</html>
