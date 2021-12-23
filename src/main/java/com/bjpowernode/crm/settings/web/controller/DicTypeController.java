package com.bjpowernode.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ClassName:DicTypeController
 * Package:com.bjpowernode.crm.settings.web.controller
 * Description:数据字典控制层
 * author:王
 */
@Controller
public class DicTypeController {
    @RequestMapping("/settings/dictionary/type/index.do")
    public String index(){

        return "settings/dictionary/type/index";
    }

}
