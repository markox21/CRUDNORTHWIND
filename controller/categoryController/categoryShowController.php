<?php
require_once '../../models/categoryModel.php';

class CategoryController {
    public function showCategories() {
        $categoryModel = new CategoryModel();
        $categories = $categoryModel->getCategories();

        return $categories;
    
        require '../../views/categories/categoryView.php';
    }

    public function showUpdateCategory($id) {
        $categoryModel = new CategoryModel();
        $categoryController = $categoryModel->selectCategory($id);

        return $categoryController;
    }
}
