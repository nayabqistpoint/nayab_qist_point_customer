import 'package:flutter/material.dart';

class TermsBlock extends StatefulWidget {
  final Function(bool isAccepted)? onTermsChanged;
  final bool initialValue;

  const TermsBlock({
    super.key, 
    this.onTermsChanged,
    this.initialValue = false,
  });

  @override
  State<TermsBlock> createState() => TermsBlockState();
}

class TermsBlockState extends State<TermsBlock> with AutomaticKeepAliveClientMixin {
  static const String termsText = '''
1. معلومات کی تصدیق: میں اقرار کرتا/کرتی ہوں کہ اس فارم میں فراہم کردہ تمام کوائف اور معلومات (میرا نام، پتہ، شناختی کارڈ، فون نمبر اور ضامن کی تفصیلات) بالکل درست اور مبنی بر حقیقت ہیں۔

2. شرائط و ضوابط کی قبولیت: میں نے ادارے (نایاب قسط پوائنٹ) کے تمام قوانین، قواعد و ضوابط اچھی طرح پڑھ اور سمجھ لیے ہیں اور میں ان سے مکمل طور پر متفق ہوں۔

3. غلط معلومات کی صورت میں قانونی کارروائی: اگر میری فراہم کردہ کسی بھی معلومات یا دستاویزی ثبوت میں جھوٹ، دھوکہ دہی يا جعل سازی ثابت ہوئی، تو ادارہ میرے خلاف تعزیراتِ پاکستان کی دفعہ 420 کے تحت فوری قانونی و عدالتی کارروائی کرنے کا مکمل حق رکھتا ہے، جس کی تمام تر ذمہ داری مجھ پر عائد ہوگی۔
''';

  final ScrollController _scrollController = ScrollController();
  late bool _isChecked;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اقرار نامہ اور ضابطہ اخلاق',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              const Text(
                'براہ کرم درج ذیل بیان حلفی اور شرائط کا مطالعہ کریں:',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Container(
                height: 140,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: const Text(
                      termsText,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 11, height: 1.5, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  setState(() {
                    _isChecked = !_isChecked;
                    if (widget.onTermsChanged != null) {
                      widget.onTermsChanged!(_isChecked);
                    }
                  });
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _isChecked,
                        activeColor: Colors.red[800],
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value ?? false;
                            if (widget.onTermsChanged != null) {
                              widget.onTermsChanged!(_isChecked);
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'میں نے شرائط پڑھ لی ہیں اور ان سے متفق ہوں',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}