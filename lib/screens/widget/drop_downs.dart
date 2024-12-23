import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cstore/Model/database_model/sys_brand_model.dart';
import 'package:cstore/screens/Language/localization_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Model/database_model/PlanogramReasonModel.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/drop_reason_model.dart';
import '../../Model/database_model/sys_market_issue_model.dart';
import '../../Model/database_model/sys_osdc_reason_model.dart';
import '../../Model/database_model/sys_osdc_type_model.dart';
import '../../Model/database_model/sys_photo_type.dart';
import '../../Model/database_model/sys_rtv_reason_model.dart';
import '../utils/appcolor.dart';

class ClientListDropDown extends StatelessWidget {
  ClientListDropDown({super.key,required this.clientKey,required this.hintText,required this.clientData,required this.onChange});

  final String hintText;
  final List<ClientModel> clientData;
  final GlobalKey<FormFieldState> clientKey;
  final Function (ClientModel clientModel) onChange;

  final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<ClientModel>(
      key: clientKey,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText.tr,
        style: const TextStyle(fontSize: 14),
      ),
      items: clientData
          .map((item) => DropdownMenuItem<ClientModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.client_name : item.client_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class CategoryDropDown extends StatefulWidget {
  CategoryDropDown({super.key,required this.categoryKey,required this.hintText,required this.categoryData,required this.onChange});
  final String hintText;
  final GlobalKey<FormFieldState> categoryKey;
  final List<CategoryModel> categoryData;
  final Function (CategoryModel clientModel) onChange;

  final languageController = Get.put(LocalizationController());

  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}
class _CategoryDropDownState extends State<CategoryDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<CategoryModel>(
      key: widget.categoryKey,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        widget.hintText.tr,
        style: const TextStyle(fontSize: 14),
      ),
      items: widget.categoryData
          .map((item) => DropdownMenuItem<CategoryModel>(
        value: item,
        child: Text(
          widget.languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        widget.onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class SysBrandDropDown extends StatelessWidget {
  SysBrandDropDown({super.key,required this.brandKey,required this.hintText,required this.brandData,required this.onChange});

  final String hintText;
  final List<SYS_BrandModel> brandData;
  final Function (SYS_BrandModel clientModel) onChange;
  final GlobalKey<FormFieldState> brandKey;
  final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<SYS_BrandModel>(
      key: brandKey,
      decoration: const InputDecoration(
        isDense: true,
        filled: true,
       fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        // border: InputBorder.none
        border: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: MyColors.appMainColor)),
      ),
      isExpanded: true,
      hint: Text(
        hintText.tr,
        style: const TextStyle(fontSize: 14),
      ),
      items: brandData
          .map((item) => DropdownMenuItem<SYS_BrandModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
class PlanoReasonDropDown extends StatelessWidget {
  PlanoReasonDropDown({super.key,required this.hintText,required this.reasonData,required this.onChange});

  final String hintText;
  final List<PlanogramReasonModel> reasonData;
  final Function (PlanogramReasonModel clientModel) onChange;
  final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<PlanogramReasonModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: reasonData.map((item) => DropdownMenuItem<PlanogramReasonModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
class TypeDropDown extends StatelessWidget {
  TypeDropDown({super.key,required this.hintText,required this.photoData,required this.onChange,required this.typeKey});

  final String hintText;
  final List<Sys_PhotoTypeModel> photoData;
  final Function (Sys_PhotoTypeModel typeModel) onChange;
final GlobalKey<FormFieldState> typeKey;
final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<Sys_PhotoTypeModel>(
      key: typeKey,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: photoData
          .map((item) => DropdownMenuItem<Sys_PhotoTypeModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
class OsdcTypeDropDown extends StatelessWidget {
   OsdcTypeDropDown({super.key,required this.hintText,required this.osdcTypeData,required this.onChange});

  final String hintText;
  final List<Sys_OSDCTypeModel> osdcTypeData;
  final Function (Sys_OSDCTypeModel typeModel) onChange;
   final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<Sys_OSDCTypeModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: osdcTypeData
          .map((item) => DropdownMenuItem<Sys_OSDCTypeModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
class OsdcReasonDropDown extends StatelessWidget {
   OsdcReasonDropDown({super.key,required this.hintText,required this.osdcReasonData,required this.onChange});
  final String hintText;
  final List<Sys_OSDCReasonModel> osdcReasonData;
  final Function (Sys_OSDCReasonModel typeModel) onChange;
   final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<Sys_OSDCReasonModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: osdcReasonData
          .map((item) => DropdownMenuItem<Sys_OSDCReasonModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
class OsdcBrandDropDown extends StatelessWidget {
   OsdcBrandDropDown({super.key,required this.hintText,required this.osdcBrandData,required this.onChange});
  final String hintText;
  final List<SYS_BrandModel> osdcBrandData;
  final Function (SYS_BrandModel typeModel) onChange;
   final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<SYS_BrandModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: osdcBrandData
          .map((item) => DropdownMenuItem<SYS_BrandModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
class ReasonDropDown extends StatelessWidget {
   ReasonDropDown({super.key,required this.hintText,required this.reasonData,required this.onChange});

  final String hintText;
  final List<DropReasonModel> reasonData;
  final Function (DropReasonModel typeModel) onChange;
   final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<DropReasonModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        // fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        fillColor: MyColors.dropBorderColor,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: reasonData
          .map((item) => DropdownMenuItem<DropReasonModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class UnitDropDown extends StatelessWidget {
  const UnitDropDown({super.key,required this.hintText,required this.unitData,required this.onChange});

  final String hintText;
  final List<String> unitData;
  final Function (String value) onChange;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        // fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        fillColor: MyColors.dropBorderColor,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: unitData
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class AdherenceDropDown extends StatelessWidget {
   AdherenceDropDown({super.key,required this.hintText,required this.unitData,required this.onChange,this.initialValue});

  final String hintText;
  final List<String> unitData;
  dynamic initialValue;
  final Function (String value) onChange;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        // fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        fillColor: MyColors.dropBorderColor,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      value: initialValue == "" ? null : initialValue,
      items: unitData
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item.tr,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

///Drop Down With Initial Value
class ClientListDropDownWithInitialValue extends StatelessWidget {
  const ClientListDropDownWithInitialValue({super.key,required this.initialValue,required this.clientKey,required this.hintText,required this.clientData,required this.onChange});

  final String hintText;
  final List<ClientModel> clientData;
  final ClientModel initialValue;
  final GlobalKey<FormFieldState> clientKey;
  final Function (ClientModel clientModel) onChange;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<ClientModel>(
      key: clientKey,
      value: initialValue,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: clientData
          .map((item) => DropdownMenuItem<ClientModel>(
        value: item,
        enabled: item.client_id != -1,
        child: Text(
          item.client_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class UnitDropDownWithInitialValue extends StatelessWidget {
  const UnitDropDownWithInitialValue({super.key,required this.hintText,required this.unitData,required this.onChange,required this.initialValue});

  final String hintText;
  final List<String> unitData;
  final Function (List<String> value) onChange;
  final List<String> initialValue;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.multiSelect(
      hintText: 'Select any reason',
      items: unitData,
      decoration: CustomDropdownDecoration(
          closedBorder: Border.all(color: MyColors.rowGreyishColor),
          closedBorderRadius: BorderRadius.circular(10),
          closedSuffixIcon: null,
          closedFillColor: MyColors.whiteColor),
      initialItems:  initialValue,
      onListChanged: (value) {
        onChange(value);
      },
    );
  }
}

class SysBrandDropDownWithInitialValue extends StatelessWidget {
   SysBrandDropDownWithInitialValue({super.key,required this.initialValue,required this.brandKey,required this.hintText,required this.brandData,required this.onChange});

  final String hintText;
  final List<SYS_BrandModel> brandData;
  final SYS_BrandModel initialValue;
  final Function (SYS_BrandModel clientModel) onChange;
  final GlobalKey<FormFieldState> brandKey;
   final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<SYS_BrandModel>(
      key: brandKey,
      value: initialValue,
      decoration: const InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        // border: InputBorder.none
        border: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: MyColors.appMainColor)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: brandData
          .map((item) => DropdownMenuItem<SYS_BrandModel>(
        value: item,
        enabled: item.id != -1,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class CategoryDropDownWithInitialValue extends StatefulWidget {
  CategoryDropDownWithInitialValue({super.key,required this.initialValue,required this.categoryKey,required this.hintText,required this.categoryData,required this.onChange});
  final String hintText;
  final GlobalKey<FormFieldState> categoryKey;
  final List<CategoryModel> categoryData;
  final CategoryModel initialValue;
  final Function (CategoryModel clientModel) onChange;
  final languageController = Get.put(LocalizationController());

  @override
  State<CategoryDropDownWithInitialValue> createState() => _CategoryDropDownWithInitialValueState();
}
class _CategoryDropDownWithInitialValueState extends State<CategoryDropDownWithInitialValue> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<CategoryModel>(
      key: widget.categoryKey,
      value: widget.initialValue.id == 0 ? null  : widget.initialValue,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        widget.hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: widget.categoryData
          .map((item) => DropdownMenuItem<CategoryModel>(
        value: item,
        enabled: item.id != -1,
        child: Text(
          widget.languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        widget.onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class RtvReasonDropDown extends StatelessWidget {
   RtvReasonDropDown({super.key,required this.hintText,required this.reasonData,required this.onChange});

  final String hintText;
  final List<Sys_RTVReasonModel> reasonData;
  final Function (Sys_RTVReasonModel typeModel) onChange;
   final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<Sys_RTVReasonModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        // fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        fillColor: MyColors.dropBorderColor,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: reasonData
          .map((item) => DropdownMenuItem<Sys_RTVReasonModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}


class MarketIssueDropDown extends StatelessWidget {
  const MarketIssueDropDown({super.key,required this.hintText,required this.reasonData,required this.onChange});

  final String hintText;
  final List<sysMarketIssueModel> reasonData;
  final Function (sysMarketIssueModel typeModel) onChange;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<sysMarketIssueModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        // fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: EdgeInsets.zero,
        // // fillColor: Colors.white,
        fillColor: MyColors.dropBorderColor,
        // border: InputBorder.none
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: reasonData
          .map((item) => DropdownMenuItem<sysMarketIssueModel>(
        value: item,
        child: Text(
          item.name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class PromReasonDropDown extends StatelessWidget {
  PromReasonDropDown({super.key,required this.hintText,required this.osdcReasonData,required this.onChange,required this.initialItem});
  final String hintText;
  final List<Sys_OSDCReasonModel> osdcReasonData;
  Sys_OSDCReasonModel initialItem;
  final Function (Sys_OSDCReasonModel typeModel) onChange;
  final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<Sys_OSDCReasonModel>(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:MyColors.dropBorderColor,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      isExpanded: true,
      value: initialItem.id == -1 || initialItem.id == 0 ? null : initialItem,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: osdcReasonData
          .map((item) => DropdownMenuItem<Sys_OSDCReasonModel>(
        value: item,
        child: Text(
          languageController.isEnglish.value ? item.en_name : item.ar_name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select driver name';
        }
        return null;
      },
      onChanged: (value) {
        onChange(value!);
      },
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}


class ProductDropDownList extends StatefulWidget {
  const ProductDropDownList({super.key,required this.skuData,required this.selectedId,required this.skuKey,required this.valueDropDownController});

 final List<Sys_PhotoTypeModel> skuData;
 final Function(int) selectedId;
  final GlobalKey<FormFieldState> skuKey;
  final SingleValueDropDownController valueDropDownController;

  @override
  State<ProductDropDownList> createState() => _ProductDropDownListState();
}

class _ProductDropDownListState extends State<ProductDropDownList> {

  @override
  Widget build(BuildContext context) {
    return widget.skuData.length == 1 && widget.skuData[0].id == -1 ? Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: MyColors.blackColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Select Sku".tr,style: const TextStyle(color: Colors.grey),),
          const Icon(Icons.arrow_drop_down,color: Colors.grey,),
        ],
      ),
    ) : Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border.all(color: MyColors.blackColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
          child: DropDownTextField(
            key: widget.skuKey,
            textFieldDecoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Select Sku".tr,
              contentPadding:const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
            ),
            listPadding: ListPadding(top: 20),
            enableSearch: true,
            clearOption: false,
            controller: widget.valueDropDownController,
            dropDownList: widget.skuData.map<DropDownValueModel>((Sys_PhotoTypeModel value) {
              return DropDownValueModel(
                  value: value.id,
                  name: value.en_name
              );
            }).toList(),
            onChanged: (val) {
              print("Value Selected");
              widget.selectedId(widget.valueDropDownController.dropDownValue!.value);

            },
          )
      ),
    );
  }
}




