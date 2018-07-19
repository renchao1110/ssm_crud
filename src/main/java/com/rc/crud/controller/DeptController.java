package com.rc.crud.controller;

import com.rc.crud.bean.Message;
import com.rc.crud.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class DeptController {
    @Autowired
    private DeptService deptService;

    @ResponseBody
    @RequestMapping("/depts")
    public Message getDepts(){
        return Message.success().add("depts",deptService.getDepts());
    }
}
