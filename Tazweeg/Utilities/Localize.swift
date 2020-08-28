//
//  Localize.swift
//  Coffee & Go
//
//  Created by Naveed ur Rehman on 19/09/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

var appFont_regular_en = "TAHOMA"
var appFont_regular_ar = "TAHOMA"
var appFont_bold_en = "TAHOMA-Bold"
var appFont_bold_ar = "TAHOMA-Bold"


import UIKit

class Localize: NSObject {
    
    static let shared = Localize()
    
    var alert = ""
   
    var ok = ""
    var cancel = ""
    var appFont = ""
    var gallery = ""
    var camera = ""
    var search = ""
    var name_is_missing = ""
    var phone_is_missing = ""
    var phone_notValid = ""
    var emirate_id_notValid = ""
    var email_notValid = ""
    var code_is_missing = ""
    var all_fields_required = ""
    var lang_required = ""
    var sign_required = ""
    var terms_required = ""
    var no_mem_found = ""
    var old_pass_miss = ""
    var new_pass_miss = ""
    var pass_6_length = ""
    var pass_not_match = ""
    var terms = ""
    var privacy_policy = "Privacy Policy"
    
    
    override init(){
        if AppDelegate.shared().lang == "en" {
            appFont = "TAHOMA"
            alert = "Alert"
            gallery = "Gallery"
            camera = "Camera"
            ok = "OK"
            cancel = "Cancel"
            search = "Search"
            name_is_missing = "Name is missing"
            phone_is_missing = "Phone number is missing"
            phone_notValid = "Phone number is not valid"
            email_notValid = "Email is not valid"
            emirate_id_notValid = "Emirate id card is not valid"
            code_is_missing = "Code is missing"
            all_fields_required = "All fields are required"
            lang_required = "Language is required"
            sign_required = "Signature is required"
            terms_required = "Please accept terms & conditions to proceed "
            no_mem_found = "No member found"
            old_pass_miss = "Old password is missing!"
            new_pass_miss = "New password is missing!"
            pass_6_length = "Password should be atleast 6 characters in length!"
            terms = "Terms Of Use"
            privacy_policy = "Privacy Policy"
            pass_not_match = "Password is not matching"
            
        } else {
            
            pass_not_match = "كلمة المرور غير متطابقة"
            appFont = "TAHOMA"
            alert =  "إنذار"
            ok = "حسنا"
            cancel = "إلغاء"
            gallery = "رواق"
            camera = "كاميرا"
            search = "بحث"
            name_is_missing = "الاسم مفقود"
            phone_is_missing = "رقم الهاتف مفقود"
            phone_notValid = "رقم الهاتف غير صالح"
            email_notValid = "البريد الإلكتروني غير صالح"
            emirate_id_notValid = "بطاقة الهوية الإماراتية غير صالحة"
            code_is_missing = "رمز مفقود"
            all_fields_required = "جميع الحقول مطلوبة"
            lang_required = "اللغة مطلوبة"
            sign_required = "التوقيع مطلوب"
            terms_required = "يرجى قبول الشروط والأحكام للمضي قدما"
            no_mem_found = "لا يوجد عضو"
            old_pass_miss = "كلمة المرور القديمة مفقودة!"
            new_pass_miss = "كلمة المرور الجديدة مفقودة!"
            pass_6_length = "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل!"
            terms = "تعليمات الاستخدام"
            privacy_policy = "سياسة الخصوصية"
        }
    }
    
}

