package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ClassName:CustomerController
 * Package:com.bjpowernode.crm.workbench.web.controller
 * Description:
 * author:王
 */
@Controller
public class CustomerController {

    @RequestMapping("workbench/customer/detail.do")
    public String detail(){
        return "workbench/customer/detail";
    }
}
