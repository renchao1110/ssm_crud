<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表</title>
	<%
		pageContext.setAttribute("APP_PATH", request.getContextPath());
	%>
<!-- web路径：
不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
		http://localhost:3306/crud
 -->
<script type="text/javascript"
	src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

</head>
<body>



<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">员工修改</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal">
					<div class="form-group">
						<label class="col-sm-2 control-label">empName</label>
						<div class="col-sm-10">
							<p class="form-control-static" id="empName_update_static"></p>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">email</label>
						<div class="col-sm-10">
							<input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
							<span class="help-block"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">gender</label>
						<div class="col-sm-10">
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
							</label>
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender2_update_input" value="F"> 女
							</label>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">deptName</label>
						<div class="col-sm-4">
							<!-- 部门提交部门id即可 -->
							<select class="form-control" name="dId" id="updateDepts">
							</select>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
			</div>
		</div>
	</div>
</div>


<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">员工添加</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal">
					<div class="form-group">
						<label class="col-sm-2 control-label">姓名：</label>
						<div class="col-sm-10">
							<input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
							<span class="help-block"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">邮箱：</label>
						<div class="col-sm-10">
							<input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
							<span class="help-block"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">性别：</label>
						<div class="col-sm-10">
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
							</label>
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender2_add_input" value="F"> 女
							</label>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">部门：</label>
						<div class="col-sm-4">
							<!-- 部门提交部门id即可 -->
							<select class="form-control" name="dId" id="depts">
							</select>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="emp_save">保存</button>
			</div>
		</div>
	</div>
</div>


	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>Spring-SpringMVC-Mybatis-CRUD-Rest</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button id="add" class="btn btn-primary">新增</button>
				<button id="emp_delete_all" class="btn btn-danger">删除</button>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-bordered" id="emps">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>员工ID</th>
							<th>员工姓名</th>
							<th>员工性别</th>
							<th>邮箱</th>
							<th>部门</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>

					</tbody>

				</table>
			</div>
		</div>

		<!-- 显示分页信息 -->
		<div class="row">
			<!--分页文字信息  -->
			<div class="col-md-6" id="page_info"></div>
			<!-- 分页条信息 -->
			<div class="col-md-6" id="page_nav">
				<nav aria-label="Page navigation">
				</nav>
			</div>
		</div>
		
	</div>
</body>

<script type="text/javascript" >

	var total,currentPage;
    $(document).ready(function(){
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url : "${APP_PATH }/emps",
            data : {pn:pn},
            type : "GET",
            success : function(result) {
                build_empstable(result);
                buile_page_info(result);
                buile_page_nav(result);
            }
        });
    }



    function build_empstable(result) {
        $("#emps tbody").empty();
        var emps = result.map.pageInfo.list;
        $.each(emps,function(index,emp){
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var empId = $("<td></td>").append(emp.empId);
            var empName = $("<td></td>").append(emp.empName);
            var gender = $("<td></td>").append(emp.gender=='M'?'男':'女');
            var email = $("<td></td>").append(emp.email);
            var deptName = $("<td></td>").append(emp.dept.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            //为编辑按钮添加一个自定义的属性，来表示当前员工id
            editBtn.attr("edit-id",emp.empId);
            var delBtn =  $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            //为删除按钮添加一个自定义的属性来表示当前删除的员工id
            delBtn.attr("del-id",emp.empId);
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>")
                .append(checkBoxTd)
                .append(empId)
                .append(empName)
                .append(gender)
                .append(email)
                .append(deptName)
                .append(btnTd)
                .appendTo("#emps tbody");
        });
    }
    //解析
    function buile_page_info(result) {
        $("#page_info").empty();
        $("#page_info").append(
            "当前第 "+result.map.pageInfo.pageNum+" 页,总共 "
            +result.map.pageInfo.pages+" 页,总 "
            +result.map.pageInfo.total+" 条记录");
        total = result.map.pageInfo.total;
        currentPage = result.map.pageInfo.pageNum;
    }


    function buile_page_nav(result) {
        $("#page_nav").empty();
        var ul = $("<ul></ul>").addClass("pagination");

        //构建元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if(result.map.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //为元素添加点击翻页的事件
            firstPageLi.click(function(){
                to_page(1);
            });
            prePageLi.click(function(){
                to_page(result.map.pageInfo.pageNum -1);
            });
        }



        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if(result.map.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            nextPageLi.click(function(){
                to_page(result.map.pageInfo.pageNum +1);
            });
            lastPageLi.click(function(){
                to_page(result.map.pageInfo.pages);
            });
        }



        //添加首页和前一页 的提示
        ul.append(firstPageLi).append(prePageLi);
        //1,2，3遍历给ul中添加页码提示
        $.each(result.map.pageInfo.navigatepageNums,function(index,item){

            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.map.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function(){
                to_page(item);
            });
            ul.append(numLi);
        });
        //添加下一页和末页 的提示
        ul.append(nextPageLi).append(lastPageLi);

        //把ul加入到nav
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav");
    }



    //清空表单样式及内容


    //点击新增按钮弹出模态框。


    //查出所有的部门信息并显示在下拉列表中
	function getDepts(obj){
        $(obj).empty();
        $.ajax({
			url:"${APP_PATH }/depts",
			type:"GET",
			success:function (result) {
			    $.each(result.map.depts,function (index,dept) {
					var options = $("<option></option>").append(dept.deptName).attr("value",dept.deptId).appendTo(obj);
                })
            }
		});
	}

	////清空表单内容，以及表单样式
	function reset_form(obj){
        $(obj)[0].reset();
        $(obj).find("*").removeClass("has-success has-error");
        $(obj).find(".help-block").text("");
	}

	//点击新增按钮弹出模态狂
    $("#add").click(function () {
        //清空表单内容
        //$("#empAddModal form")[0].reset();
        reset_form("#empAddModal form");
        getDepts("#depts");
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });


    //显示校验结果的提示信息
    function show_validate_msg(ele,status,msg){
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //校验数据的合法性
    function validate(){
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if(!regName.test(empName)){
            show_validate_msg("#empName_add_input", "error", "用户名必须是2-5位中文或者6-16位英文和数字的组合");
            return false;
        }else{
            show_validate_msg("#empName_add_input", "success", "");
        };

        //2、校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            //应该清空这个元素之前的样式
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
            return false;
        }else{
            show_validate_msg("#email_add_input", "success", "");
        }
        return true;

	}

	//校验empName是否可用
	$("#empName_add_input").change(function(){
	    $.ajax({
			url:"${APP_PATH }/checkEmp",
			type:"POST",
			data:{"empName":this.value},
			success:function (result) {
                if(result.state==200){
                    show_validate_msg("#empName_add_input","success","用户名可用");
                    $("#emp_save").attr("ajax-va","success");
                }else{
                    show_validate_msg("#empName_add_input","error",result.map.message);
                    $("#emp_save").attr("ajax-va","error");
                }
            }
		});
	});


	//emp保存方法
    $("#emp_save").click(function(){
        if(validate()){
            if($(this).attr("ajax-va")=="error"){
                return false;
			}
            $.ajax({
                url:"${APP_PATH }/saveEmp",
                type:"POST",
                data:$("#empAddModal form").serialize(),
                success:function (result) {
                    if(result.state=="200"){
                        $("#empAddModal").modal("hide");
                        alert(result.msg);
                        to_page(total);
                    }else{
                        //alert(result.map.fieldErrors.email);
                        if(undefined != result.map.fieldErrors.email){
                            show_validate_msg("#email_add_input", "error",result.map.fieldErrors.email);
                        }
                        if(undefined != result.map.fieldErrors.empName){
                            show_validate_msg("#empName_add_input", "error",result.map.fieldErrors.empName);
                        }
                    }
                }
            });
		};
	});


    //1、我们是按钮创建之前就绑定了click，所以绑定不上。
    //1）、可以在创建按钮的时候绑定。    2）、绑定点击.live()
    //jquery新版没有live，使用on进行替代
	$(document).on("click",".edit_btn",function(){

        getEmp($(this).attr("edit-id"));
        //3、把员工的id传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
        getDepts("#updateDepts");
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
	});


	//
	function getEmp(id) {
		$.ajax({
			url:"${APP_PATH}/emp/"+id,
			type:"GET",
			success:function (result) {
                var empData = result.map.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
            }
		});
    }


    //点击更新，更新员工信息
    $("#emp_update_btn").click(function(){
        //验证邮箱是否合法
        //1、校验邮箱信息
        var email = $("#email_update_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
            return false;
        }else{
            show_validate_msg("#email_update_input", "success", "");
        }

        //2、发送ajax请求保存更新的员工数据
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            type:"PUT",
            data:$("#empUpdateModal form").serialize(),
            success:function(result){
                //1、关闭对话框
                $("#empUpdateModal").modal("hide");
                //2、回到本页面
                to_page(currentPage);
            }
        });
    });


    //单个删除
    $(document).on("click",".delete_btn",function(){
        //1、弹出是否确认删除对话框
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("del-id");
        if(confirm("确认删除【"+empName+"】吗？")){
            //确认，发送ajax请求删除即可
            $.ajax({
                url:"${APP_PATH}/emp/"+empId,
                type:"DELETE",
                success:function(result){
                    alert(result.map.message);
                    //回到本页
                    to_page(currentPage);
                }
            });
        }
    });
    
    
    //全选
	$("#check_all").click(function () {
		$(".check_item").prop("checked",$(this).prop("checked"));
    });

	//
	$(document).on("click",".check_item",function () {
	    var bl = $(".check_item:checked").length==$(".check_item").length;
	    if(bl){
            $("#check_all").prop("checked",bl);
		}else {
            $("#check_all").prop("checked",bl);
		}
    })


	$("#emp_delete_all").click(function () {
        var empIds = "";
		var empNames = "";
		$.each($(".check_item:checked"),function () {
            empNames+=$(this).parents("tr").find("td:eq(2)").text()+",";
            empIds+=$(this).parents("tr").find("td:eq(1)").text()+"-";
        });

        empNames = empNames.substring(0,empNames.length-1);
        empIds = empIds.substring(0,empIds.length-1);
		if(confirm("确认要删除["+empNames+"]吗？")){
            //确认，发送ajax请求删除即可
            $.ajax({
                url:"${APP_PATH}/emp/"+empIds,
                type:"DELETE",
                success:function(result){
                    alert(result.map.message);
                    //回到本页
                    to_page(currentPage);
                }
            });
		}
    });
</script>
</html>