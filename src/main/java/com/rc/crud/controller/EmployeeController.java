package com.rc.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.rc.crud.bean.Employee;
import com.rc.crud.bean.Message;
import com.rc.crud.service.EmployeeService;
import com.sun.tools.javac.code.Attribute;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {

    @Resource
    EmployeeService employeeService;


    //传统的返回jsp页面处理
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
        PageHelper.startPage(pn,10);
        List<Employee> emps = employeeService.getAll();
        PageInfo<Employee> info = new PageInfo<Employee>(emps,5);
        model.addAttribute("pageInfo",info);
        return "list";
    }

    //通用的直接返回json给请求端，让其自行处理
    @RequestMapping("/emps")
    @ResponseBody
    public Message getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        PageHelper.startPage(pn,10);
        List<Employee> emps = employeeService.getAll();
        PageInfo<Employee> info = new PageInfo<Employee>(emps,5);
        return Message.success().add("pageInfo",info);
    }



    //保存员工信息
    @RequestMapping(value="/saveEmp",method=RequestMethod.POST)
    @ResponseBody
    public Message saveEmp(@Valid Employee emp,BindingResult result){
        if(result.hasErrors()){
            Map<String,Object> map = new HashMap<>();
            List<FieldError> fieldErrors = result.getFieldErrors();
            for (FieldError fieldError:fieldErrors){
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Message.fail().add("fieldErrors",map);
        }else {
            employeeService.saveEmp(emp);
            Message m = new Message();
            m.setState("200");
            m.setMsg("保存成功");
            return m;
        }
    }

    //保存员工信息
    @RequestMapping(value="/checkEmp",method=RequestMethod.POST)
    @ResponseBody
    public Message checkUser(@RequestParam(value = "empName") String empName){
        //判断用户名是否合法
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if(!empName.matches(regx)){
            return Message.fail().add("message","用户名必须是2-5位中文或者6-16位英文和数字的组合");
        }
        boolean bl = employeeService.checkEmp(empName);
        if(bl){
            return Message.success();
        }else {
            return Message.fail().add("message","用户已存在");
        }
    }


    //根据员工id查询员工信息
    @RequestMapping(value="/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Message getEmp(@PathVariable("id") Integer id){
        Employee emp = employeeService.getEmpById(id);
        return Message.success().add("emp",emp);
    }



    //根据员工id查询员工信息
    @RequestMapping(value="/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Message updateEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Message.success();
    }


    //根据员工id删除员工信息---也支持批量删除
    @RequestMapping(value="/emp/{empId}",method = RequestMethod.DELETE)
    @ResponseBody
    public Message deleteEmpById(@PathVariable(value = "empId") String empId){
        if (empId.contains("-")){
            List<Integer> list_id = new ArrayList<>();
            String[] ids = empId.split("-");
            for (String id:ids){
                list_id.add(Integer.parseInt(id));
            }
            employeeService.deleteBatch(list_id);
        }else {
            int id = Integer.parseInt(empId);
            employeeService.deleteEmp(id);
        }

        return Message.success().add("message","删除成功!");
    }
}
