package com.bjpowernode.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ClassName:DicValueController
 * Package:com.bjpowernode.crm.settings.web.controller
 * Description:数据字典值
 * author:王
 */
@Controller
public class DicValueController {

    @RequestMapping("settings/dictionary/value/index.do")
    public String index(){
        return "settings/dictionary/value/index";
    }
}
