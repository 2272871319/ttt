package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.awt.*;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.workbench.web.controller
 * author:郭鑫
 */
@Controller
public class WorkBenchController {

    @RequestMapping("/workbench/index.do")
    public String index() {

        return "workbench/index";
    }

    //自己写的工作台主页面
    @RequestMapping("/workbench/main/index.do")
    public String hello(){
        return "workbench/main/index";
    }



    /**
     * 交易
     * @return
     */
    @RequestMapping("workbench/transaction/index.do")
    public String transaction(){
        return "workbench/transaction/index";
    }

}
