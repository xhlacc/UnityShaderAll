#region 模块信息
/*----------------------------------------------------------------
// Copyright (C) 2015 
//
// 模块名：ModelProcessor
// 创建者：Leon Xu
// 修改者列表：
// 创建日期：2016.8.15
// 模块描述：模型导入设置
//----------------------------------------------------------------*/
#endregion

using UnityEngine;
using System.Collections;
using UnityEditor;

public class ModelProcessor : AssetPostprocessor
{
    //导入前设置
    private void OnPreprocessModel()
    {
        ModelImporter modelImporter = (ModelImporter)assetImporter;
        
        //不导入默认材质
        modelImporter.importMaterials = false;
    }

    //模型导入后的处理
    private void OnPostprocessModel(GameObject go)
    {
        
    }
}
