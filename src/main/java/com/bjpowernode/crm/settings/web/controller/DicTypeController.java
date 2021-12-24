package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.utils.Result;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * ClassName:DicTypeController
 * Package:com.bjpowernode.crm.settings.web.controller
 * Description:数据字典控制层
 * author:王
 */
@Controller
public class DicTypeController {
    @Autowired
    private DicTypeService dicTypeService;

    @RequestMapping("/settings/dictionary/type/index.do")
    public String index(){

        return "settings/dictionary/type/index";
    }

    //查看全部字典类型
    @RequestMapping("settings/dictionary/type/queryAllDicTypeList.do")
    public @ResponseBody
    Object queryAllDicTypeList(){
        List<DicType> dicTypeList = dicTypeService.queryAllDicTypeList();
        return dicTypeList;
    }

    //'创建'按钮页面转发
    @RequestMapping("/settings/dictionary/type/createDicTypeBtn.do")
    public String createDicTypeBtn(){
        return "settings/dictionary/type/save";
    }
    //判断编码是否重复
    @RequestMapping("settings/dictionary/type/checkTypeCode.do")
    @ResponseBody
    public Object checkTypeCode(@RequestParam(value = "code",required = true)String code){
        //根据编码查数据库
        DicType dicType = dicTypeService.querydicTypeByCode(code);

        if (dicType != null){
            return Result.fail("编码重复");
        }
        return Result.success();
    }
}
