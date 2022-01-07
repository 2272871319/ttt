package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ClassName:ContactsController
 * Package:com.bjpowernode.crm.workbench.web.controller
 * Description:
 * author:王
 */
@Controller
public class ContactsController {

    @RequestMapping("workbench/contacts/detail.do")
    public String detail(){
        return "workbench/contacts/detail";
    }
}
