package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.utils.Result;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DicTypeService;
import jdk.nashorn.internal.ir.RuntimeNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
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

    //保存数据
    @RequestMapping("settings/dictionary/type/saveCreateDicType.do")
    @ResponseBody
    public Object saveCreateDicType(DicType dicType){
        try {
            int count = dicTypeService.saveCreateDicType(dicType);
            if (count != 1){
                return Result.fail("保存失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败");
        }
        return Result.success();
    }

    //编辑界面根据code查找内容
    @RequestMapping("/settings/dictionary/type/editDicTypePage.do")
    public String editDicTypePage(HttpServletRequest request, @RequestParam(value = "code",required = true)String code){

        DicType dicType = dicTypeService.querydicTypeByCode(code);
        request.setAttribute("dicType", dicType);

        return "settings/dictionary/type/edit";
    }

    @RequestMapping("/settings/dictionary/type/saveEditDicType.do")
    @ResponseBody
    public Object saveEditDicType(DicType dicType){
        //更新数据字典
        try {
            int count = dicTypeService.saveEditDicType(dicType);
            if (count != 1){
                return Result.fail("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败");
        }
        return Result.success();
    }

    @RequestMapping("settings/dictionary/type/deleteDicType.do")
    @ResponseBody
    public Object deleteDicType(String[] code){
        //批量删除
        try {
            int count = dicTypeService.deleteDicType(code);
        } catch (Exception e) {
            e.printStackTrace();
            Result.fail("删除失败");
        }
        return Result.success();
    }

}
