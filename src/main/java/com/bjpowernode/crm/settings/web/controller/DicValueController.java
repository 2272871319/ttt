package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

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
