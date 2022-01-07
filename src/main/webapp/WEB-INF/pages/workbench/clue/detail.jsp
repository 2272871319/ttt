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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});

		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#remarksDiv").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});
		$("#remarksDiv").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});
		$("#remarksDiv").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		});
		$("#remarksDiv").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		//查询备注
		queryAllClueRemarkById();
		//编辑备注中的更新按钮
		$("#updateRemarkBtn").on("click",function () {
			//拿到主键id和备注框内容
			var noteContent = $("#edit-noteContent").val();
			var id = $("#remarkId").val();
			if (noteContent == ''){
				alert("备注不能为空哦")
			}
			//发送请求更新数据
			$.ajax({
				url:"workbench/clue/detail/updateRemark.do",
				type:"post",
				data:{
					id:id,
					noteContent:noteContent
				},
				success:function (data) {
					if (data.code == 1){
						$("#editRemarkModal").modal("hide");
						queryAllClueRemarkById();
					}else {
						alert(data.message);
					}

				}
			})
		});
		//新增备注中的保存按钮
		$("#detailRemarkInsertBtn").on("click",function () {
			//拿到备注内容和该页面对象的id
			var remark = $("#remark").val();
			var clueId = "${clue.id}";

			$.ajax({
				url:"workbench/clue/detail/detailRemarkInsert.do",
				type:"post",
				data:{
					noteContent: remark,
					clueId:clueId
				},
				success:function (data) {
					if (data.code == 1){
						alert("保存成功")
						$("#cancelBtn").click();
						$("#remark").val("");
						queryAllClueRemarkById();
					}else {
						alert(data.message);
					}
				}
			})
		});

		//查询关联的市场活动
		queryAllClueActivityRelation();
		//关联活动窗口中的关联按钮
		$("#saveBundActivityBtn").on("click",function () {
			var clueId = "${clue.id}";
			//拿到被选中的复选框
			var checkboxs = $("#tBody input[type=checkbox]:checked");
			if (checkboxs.length == 0){
				alert("还没有选中哦");
			}

			var ids = "";
			$.each(checkboxs,function (index,obj) {
				ids += obj.value+",";
			});
			ids = ids.substring(0,ids.length-1);

			$.ajax({
				url:"workbench/clue/detail/saveBundActivity.do",
				type:"get",
				data:{
					id:ids,
					clueId:clueId
				},
				success:function (data) {
					if (data.code != 0){
						$("#bundModal").modal("hide");
						queryAllClueActivityRelation()
					}else {
						alert(data.message);
					}
				}
			})
		});
		//关联活动中的模糊搜索框
		$("#searchActivityName").on("keyup",function () {
			//搜索框的内容
			var searchActivityName = $("#searchActivityName").val();
			//拿到线索id
			var clueId = "${clue.id}";

			$.ajax({
				url:"workbench/clue/detail/showConvert.do",
				type:"get",
				data:{
					clueId:clueId,
					searchActivityName:searchActivityName
				},
				success:function (data) {
					var str = "";

					//显示数据
					$.each(data, function (index, list) {

						str += "<tr class=\"active\">";
						str += "<td><input type=\"checkbox\" value='" + list.id + "'/></td>";
						str += "<td>" + list.name + "</td>";
						str += "<td>" + list.startDate + "</td>";
						str += "<td>" + list.endDate + "</td>";
						str += "<td>" + list.owner + "</td>";
						str += "</tr>";
					});

					$("#tBody").html(str);
				}
			})
		});

		//转换按钮
		$("#convertBtn").on("click",function () {
			//拿到该用户主键
			var cluId ="${clue.id}";
			window.location.href = "workbench/clue/convert.do?id="+cluId;
		})
	});
	//查看全部备注
	function queryAllClueRemarkById() {
		//拿到该用户主键
		var cluId ="${clue.id}";
		//发送请求根据主键查询备注表
		$.ajax({
			url:"workbench/clue/detail/queryAllClueRemarkById.do",
			type:"get",
			data:{
				id:cluId
			},
			success:function (data) {
				var str = "";
				$.each(data,function (index,list) {
					//遍历集合
					str += "<div class=\"remarkDiv\" style=\"height: 60px;\">";
					str += "<img title=\""+list.creatBy+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
					str += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
					str += "<h5>"+list.noteContent+"</h5>";
					str += "<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "+list.createTime+" 由 "+list.createBy+" 创建 上次修改人:"+list.editBy+"</small>";
					str += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
					str += "<a class=\"myHref\" href='javascript:void(0)' onclick=\"updateDiv('"+list.id+"','"+list.noteContent+"')\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
					str += "&nbsp;&nbsp;&nbsp;&nbsp;";
					str += "<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"deleteDiv('"+list.id+"')\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
					str += "</div>";
					str += "</div>";
					str += "</div>";

				});

				$("#remarksDiv").html(str)
			}
		})
	}
	//备注编辑按钮
	function updateDiv(id,noteContent) {
		$("#editRemarkModal").modal("show");
		$("#edit-noteContent").val(noteContent);
		$("#remarkId").val(id);
	}
	//删除备注按钮
	function deleteDiv(id) {
		if (confirm("确定删除吗")) {
			$.ajax({
				url: "workbench/clue/detail/deleteDiv.do",
				type: "post",
				data: {
					id: id
				},
				success: function (data) {
					if (data.code == 1) {
						alert("删除成功")
						queryAllClueRemarkById();
					} else {
						alert(data.message)
					}
				}
			})
		}
	}
	//直接 查询关联的市场活动
	function queryAllClueActivityRelation() {
		var id = "${clue.id}";
		$.ajax({
			url:"workbench/clue/detail/queryAllClueActivityRelation.do",
			type:"post",
			data:{
				id:id
			},
			success:function (data) {

				var str = "";
				//显示数据
				$.each(data,function(index,list) {

					str += "<tr>";
					//str += "<td><input type=\"checkbox\" value='" + list.id + "'/></td>";
					str += "<td>" + list.name + "</td>";
					str += "<td>" + list.startDate + "</td>";
					str += "<td>" + list.endDate + "</td>";
					str += "<td>" + list.owner + "</td>";
					str += "<td><a href=\"javascript:void(0);\" onclick=\"deleteRelation('"+list.id+"')\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
					str += "</tr>";
				});

				$("#relationTBody").html(str)
			}
		})
	}
	//解除关联市场活动
	function deleteRelation(id) {
		var clueId = "${clue.id}";
		$.ajax({
			url:"workbench/clue/detail/deleteRelation.do",
			type:"post",
			data:{
				id:id,
				clueId:clueId
			},
			success:function (data) {
				if (data.code == 1){
					alert("解除关联成功");
					queryAllClueActivityRelation();
				}else {
					alert(data.message)
				}
			}
		})
	}
	//弹窗查询 关联市场活动按钮
	function showConvert() {
		//显示关联市场窗口
		$("#bundModal").modal("show");
		//拿到线索id
		var clueId = "${clue.id}";

		$.ajax({
			url:"workbench/clue/detail/showConvert.do",
			type:"get",
			data:{
				clueId:clueId
			},
			success:function (data) {
				var str = "";

				//显示数据
				$.each(data, function (index, list) {

					str += "<tr class=\"active\">";
					str += "<td><input type=\"checkbox\" value='" + list.id + "'/></td>";
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

</script>

</head>
<body>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchActivityName" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="checkedAll"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="saveBundActivityBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>

	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullName}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="convertBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-retweet"></span> 转换</button>

		</div>
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullName}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>

	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;" >
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<!--作业：显示备注信息-->
		<div id="remarksDiv">

			<!-- 备注1 -->
			<div class="remarkDiv" style="height: 60px;">
				<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>本条加载中。。。。</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullName}${clue.appellation}-加载中。。</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</div>


		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="detailRemarkInsertBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>

	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="relationTBody">
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</tbody>
				</table>
			</div>

			<div>
				<a id="bundActivityBtn" href="javascript:void(0);" onclick="showConvert()" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>


	<div style="height: 200px;"></div>
</body>
</html>
