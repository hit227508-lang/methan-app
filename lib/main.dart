import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

/* --------------------------- Languages ----------------------------- */

/// Current language code: 'gu' (Gujarati), 'hi' (Hindi), 'en' (English)
String currentLang = 'gu';

const languageNames = {
  'gu': 'ગુજરાતી',
  'hi': 'हिन्दी',
  'en': 'English',
};

const Map<String, Map<String, String>> strings = {
  'en': {
    'appTitle': 'Methan Yuvak Mitra Mandal',
    'newEntry': 'Add new',
    'searchHint': 'Search by name, city or mobile',
    'noData': 'No data yet. Tap the button below.',
    'details': 'Full details',
    'deleteTitle': 'Delete this entry?',
    'deleteBody': "@name's data will be deleted permanently.",
    'no': 'No',
    'yesDelete': 'Yes, delete',
    'fullName': 'Full name *',
    'fatherName': "Father's name",
    'address': 'Home address',
    'city': 'Village / City',
    'dob': 'Date of birth',
    'gender': 'Gender',
    'blood': 'Blood group',
    'marital': 'Marital status',
    'education': 'Education',
    'occupation': 'Occupation',
    'mobile': 'Mobile number',
    'email': 'Email',
    'notes': 'More information',
    'save': 'Save',
    'newForm': 'New bio data',
    'editForm': 'Edit bio data',
    'enterName': 'Please enter the name',
    'camera': 'Take photo with camera',
    'gallery': 'Choose from gallery',
    'male': 'Male',
    'female': 'Female',
    'other': 'Other',
    'single': 'Unmarried',
    'married': 'Married',
    'years': 'years',
    'chooseLanguage': 'Choose language',
  },
  'gu': {
    'appTitle': 'મેથાણ યુવક મિત્ર મંડળ',
    'newEntry': 'નવું ઉમેરો',
    'searchHint': 'નામ, ગામ કે મોબાઇલથી શોધો',
    'noData': 'હજુ કોઈ ડેટા નથી. નીચેનું બટન દબાવો.',
    'details': 'પૂરી માહિતી',
    'deleteTitle': 'ડિલીટ કરવું છે?',
    'deleteBody': '@name નો બધો ડેટા કાયમ માટે કાઢી નંખાશે.',
    'no': 'ના',
    'yesDelete': 'હા, ડિલીટ કરો',
    'fullName': 'પૂરું નામ *',
    'fatherName': 'પિતાજીનું નામ',
    'address': 'ઘરનું સરનામું',
    'city': 'ગામ / શહેર',
    'dob': 'જન્મ તારીખ',
    'gender': 'જાતિ',
    'blood': 'બ્લડ ગ્રુપ',
    'marital': 'લગ્ન સ્થિતિ',
    'education': 'શિક્ષણ',
    'occupation': 'કામ / વ્યવસાય',
    'mobile': 'મોબાઇલ નંબર',
    'email': 'ઈમેઇલ',
    'notes': 'વધુ માહિતી',
    'save': 'સેવ કરો',
    'newForm': 'નવો બાયો ડેટા',
    'editForm': 'બાયો ડેટા બદલો',
    'enterName': 'કૃપા કરીને નામ લખો',
    'camera': 'કેમેરાથી ફોટો લો',
    'gallery': 'ગેલેરીમાંથી ફોટો પસંદ કરો',
    'male': 'પુરુષ',
    'female': 'સ્ત્રી',
    'other': 'અન્ય',
    'single': 'અવિવાહિત',
    'married': 'વિવાહિત',
    'years': 'વર્ષ',
    'chooseLanguage': 'ભાષા પસંદ કરો',
  },
  'hi': {
    'appTitle': 'मेथाण युवक मित्र मंडल',
    'newEntry': 'नया जोड़ें',
    'searchHint': 'नाम, गाँव या मोबाइल से खोजें',
    'noData': 'अभी कोई डेटा नहीं है। नीचे का बटन दबाएँ।',
    'details': 'पूरी जानकारी',
    'deleteTitle': 'डिलीट करना है?',
    'deleteBody': '@name का सारा डेटा हमेशा के लिए हट जाएगा।',
    'no': 'नहीं',
    'yesDelete': 'हाँ, डिलीट करें',
    'fullName': 'पूरा नाम *',
    'fatherName': 'पिताजी का नाम',
    'address': 'घर का पता',
    'city': 'गाँव / शहर',
    'dob': 'जन्म तारीख',
    'gender': 'लिंग',
    'blood': 'ब्लड ग्रुप',
    'marital': 'वैवाहिक स्थिति',
    'education': 'शिक्षा',
    'occupation': 'काम / व्यवसाय',
    'mobile': 'मोबाइल नंबर',
    'email': 'ईमेल',
    'notes': 'अधिक जानकारी',
    'save': 'सेव करें',
    'newForm': 'नया बायो डेटा',
    'editForm': 'बायो डेटा बदलें',
    'enterName': 'कृपया नाम लिखें',
    'camera': 'कैमरे से फोटो लें',
    'gallery': 'गैलरी से फोटो चुनें',
    'male': 'पुरुष',
    'female': 'महिला',
    'other': 'अन्य',
    'single': 'अविवाहित',
    'married': 'विवाहित',
    'years': 'वर्ष',
    'chooseLanguage': 'भाषा चुनें',
  },
};

/// Translate a key into the current language.
String t(String key) => strings[currentLang]?[key] ?? strings['en']![key] ?? key;

Future<void> saveLanguage(String code) async {
  currentLang = code;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lang', code);
}

/// Shows the language picker. Returns true if a language was chosen.
Future<bool> showLanguageDialog(BuildContext context,
    {bool dismissible = true}) async {
  final choice = await showDialog<String>(
    context: context,
    barrierDismissible: dismissible,
    builder: (c) => SimpleDialog(
      title: Text(
          '${strings['gu']!['chooseLanguage']} / ${strings['hi']!['chooseLanguage']} / ${strings['en']!['chooseLanguage']}'),
      children: languageNames.entries
          .map((e) => SimpleDialogOption(
                onPressed: () => Navigator.pop(c, e.key),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(children: [
                    Icon(
                      e.key == currentLang
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    const SizedBox(width: 12),
                    Text(e.value, style: const TextStyle(fontSize: 18)),
                  ]),
                ),
              ))
          .toList(),
    ),
  );
  if (choice == null) return false;
  await saveLanguage(choice);
  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('lang');
  if (saved != null && languageNames.containsKey(saved)) currentLang = saved;
  runApp(BioDataApp(firstRun: saved == null));
}

/* ------------------------------ Model ------------------------------ */

class Person {
  int? id;
  String name;
  String fatherName;
  String address;
  String city;
  String dob;
  String gender; // key: male / female / other
  String bloodGroup;
  String maritalStatus; // key: single / married / other
  String education;
  String occupation;
  String mobile;
  String email;
  String notes;
  String photoPath;

  Person({
    this.id,
    this.name = '',
    this.fatherName = '',
    this.address = '',
    this.city = '',
    this.dob = '',
    this.gender = '',
    this.bloodGroup = '',
    this.maritalStatus = '',
    this.education = '',
    this.occupation = '',
    this.mobile = '',
    this.email = '',
    this.notes = '',
    this.photoPath = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'fatherName': fatherName,
        'address': address,
        'city': city,
        'dob': dob,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'maritalStatus': maritalStatus,
        'education': education,
        'occupation': occupation,
        'mobile': mobile,
        'email': email,
        'notes': notes,
        'photoPath': photoPath,
      };

  factory Person.fromMap(Map<String, Object?> m) => Person(
        id: m['id'] as int?,
        name: (m['name'] ?? '') as String,
        fatherName: (m['fatherName'] ?? '') as String,
        address: (m['address'] ?? '') as String,
        city: (m['city'] ?? '') as String,
        dob: (m['dob'] ?? '') as String,
        gender: (m['gender'] ?? '') as String,
        bloodGroup: (m['bloodGroup'] ?? '') as String,
        maritalStatus: (m['maritalStatus'] ?? '') as String,
        education: (m['education'] ?? '') as String,
        occupation: (m['occupation'] ?? '') as String,
        mobile: (m['mobile'] ?? '') as String,
        email: (m['email'] ?? '') as String,
        notes: (m['notes'] ?? '') as String,
        photoPath: (m['photoPath'] ?? '') as String,
      );

  /// DOB "dd/MM/yyyy" ma hoy to umar kadhe.
  String get age {
    try {
      final parts = dob.split('/');
      if (parts.length != 3) return '';
      final d = DateTime(
          int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      final now = DateTime.now();
      int a = now.year - d.year;
      if (now.month < d.month || (now.month == d.month && now.day < d.day)) {
        a--;
      }
      return a >= 0 ? '$a ${t('years')}' : '';
    } catch (_) {
      return '';
    }
  }
}

/* ----------------------------- Database ---------------------------- */

class DB {
  DB._();
  static final DB instance = DB._();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'biodata.db');
    _db = await openDatabase(path, version: 1, onCreate: (d, v) async {
      await d.execute('''
        CREATE TABLE persons(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT, fatherName TEXT, address TEXT, city TEXT, dob TEXT,
          gender TEXT, bloodGroup TEXT, maritalStatus TEXT, education TEXT,
          occupation TEXT, mobile TEXT, email TEXT, notes TEXT, photoPath TEXT
        )''');
    });
    return _db!;
  }

  Future<List<Person>> all([String q = '']) async {
    final d = await db;
    final rows = q.isEmpty
        ? await d.query('persons', orderBy: 'name COLLATE NOCASE')
        : await d.query('persons',
            where: 'name LIKE ? OR city LIKE ? OR mobile LIKE ?',
            whereArgs: ['%$q%', '%$q%', '%$q%'],
            orderBy: 'name COLLATE NOCASE');
    return rows.map(Person.fromMap).toList();
  }

  Future<void> save(Person x) async {
    final d = await db;
    if (x.id == null) {
      await d.insert('persons', x.toMap()..remove('id'));
    } else {
      await d.update('persons', x.toMap()..remove('id'),
          where: 'id = ?', whereArgs: [x.id]);
    }
  }

  Future<void> delete(int id) async {
    final d = await db;
    await d.delete('persons', where: 'id = ?', whereArgs: [id]);
  }
}

/* ------------------------------- App ------------------------------- */

class BioDataApp extends StatelessWidget {
  final bool firstRun;
  const BioDataApp({super.key, required this.firstRun});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'મેથાણ યુવક મિત્ર મંડળ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3F51B5),
      ),
      home: ListScreen(firstRun: firstRun),
    );
  }
}

Widget avatar(String path, double radius) {
  final has = path.isNotEmpty && File(path).existsSync();
  return CircleAvatar(
    radius: radius,
    backgroundImage: has ? FileImage(File(path)) : null,
    child: has ? null : Icon(Icons.person, size: radius),
  );
}

/// Dropdown ni keys ne current language ma translate kare.
String label(String key) => key.isEmpty ? '' : t(key);

/* ---------------------------- List screen -------------------------- */

class ListScreen extends StatefulWidget {
  final bool firstRun;
  const ListScreen({super.key, this.firstRun = false});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Person> people = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    load();
    if (widget.firstRun) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Pehli var app khule tyare bhasha puchho.
        if (await showLanguageDialog(context, dismissible: false) && mounted) {
          setState(() {});
        }
      });
    }
  }

  Future<void> load() async {
    final r = await DB.instance.all(query);
    if (mounted) setState(() => people = r);
  }

  Future<void> changeLanguage() async {
    if (await showLanguageDialog(context) && mounted) setState(() {});
  }

  Future<void> openForm([Person? person]) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => FormScreen(person: person)));
    load();
  }

  Future<void> openDetail(Person person) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => DetailScreen(person: person)));
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('appTitle')),
        actions: [
          IconButton(
            tooltip: t('chooseLanguage'),
            onPressed: changeLanguage,
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openForm(),
        icon: const Icon(Icons.person_add),
        label: Text(t('newEntry')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: t('searchHint'),
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) {
                query = v.trim();
                load();
              },
            ),
          ),
          Expanded(
            child: people.isEmpty
                ? Center(child: Text(t('noData')))
                : ListView.separated(
                    itemCount: people.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final x = people[i];
                      return ListTile(
                        leading: avatar(x.photoPath, 26),
                        title: Text(x.name),
                        subtitle: Text(
                            [x.city, x.mobile].where((e) => e.isNotEmpty).join(' • ')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => openDetail(x),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/* --------------------------- Detail screen ------------------------- */

class DetailScreen extends StatefulWidget {
  final Person person;
  const DetailScreen({super.key, required this.person});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Person x;

  @override
  void initState() {
    super.initState();
    x = widget.person;
  }

  Future<void> edit() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => FormScreen(person: x)));
    final all = await DB.instance.all();
    final fresh = all.where((e) => e.id == x.id);
    if (!mounted) return;
    if (fresh.isEmpty) {
      Navigator.pop(context);
    } else {
      setState(() => x = fresh.first);
    }
  }

  Future<void> remove() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t('deleteTitle')),
        content: Text(t('deleteBody').replaceAll('@name', x.name)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false), child: Text(t('no'))),
          FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: Text(t('yesDelete'))),
        ],
      ),
    );
    if (ok == true) {
      await DB.instance.delete(x.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  Widget row(IconData icon, String title, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: Theme.of(context).textTheme.bodySmall),
      subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('details')),
        actions: [
          IconButton(onPressed: edit, icon: const Icon(Icons.edit)),
          IconButton(onPressed: remove, icon: const Icon(Icons.delete)),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(child: avatar(x.photoPath, 70)),
          const SizedBox(height: 12),
          Center(
              child: Text(x.name,
                  style: Theme.of(context).textTheme.headlineSmall)),
          const SizedBox(height: 12),
          const Divider(),
          row(Icons.family_restroom, t('fatherName'), x.fatherName),
          row(Icons.home, t('address'), x.address),
          row(Icons.location_city, t('city'), x.city),
          row(Icons.cake, t('dob'), x.dob.isEmpty ? '' : '${x.dob}  (${x.age})'),
          row(Icons.wc, t('gender'), label(x.gender)),
          row(Icons.bloodtype, t('blood'), x.bloodGroup),
          row(Icons.favorite, t('marital'), label(x.maritalStatus)),
          row(Icons.school, t('education'), x.education),
          row(Icons.work, t('occupation'), x.occupation),
          row(Icons.phone, t('mobile'), x.mobile),
          row(Icons.email, t('email'), x.email),
          row(Icons.notes, t('notes'), x.notes),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/* ---------------------------- Form screen -------------------------- */

class FormScreen extends StatefulWidget {
  final Person? person;
  const FormScreen({super.key, this.person});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _key = GlobalKey<FormState>();
  late Person x;

  late final name = TextEditingController();
  late final father = TextEditingController();
  late final address = TextEditingController();
  late final city = TextEditingController();
  late final dob = TextEditingController();
  late final education = TextEditingController();
  late final occupation = TextEditingController();
  late final mobile = TextEditingController();
  late final email = TextEditingController();
  late final notes = TextEditingController();

  String gender = '';
  String blood = '';
  String marital = '';
  String photo = '';

  static const genders = ['male', 'female', 'other'];
  static const bloods = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  static const maritals = ['single', 'married', 'other'];

  @override
  void initState() {
    super.initState();
    x = widget.person ?? Person();
    name.text = x.name;
    father.text = x.fatherName;
    address.text = x.address;
    city.text = x.city;
    dob.text = x.dob;
    education.text = x.education;
    occupation.text = x.occupation;
    mobile.text = x.mobile;
    email.text = x.email;
    notes.text = x.notes;
    gender = x.gender;
    blood = x.bloodGroup;
    marital = x.maritalStatus;
    photo = x.photoPath;
  }

  Future<void> pickPhoto(ImageSource source) async {
    final f = await ImagePicker()
        .pickImage(source: source, maxWidth: 1000, imageQuality: 85);
    if (f == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final dest = p.join(
        dir.path, 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await File(f.path).copy(dest);
    setState(() => photo = dest);
  }

  void photoSheet() {
    showModalBottomSheet(
      context: context,
      builder: (c) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: Text(t('camera')),
            onTap: () {
              Navigator.pop(c);
              pickPhoto(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(t('gallery')),
            onTap: () {
              Navigator.pop(c);
              pickPhoto(ImageSource.gallery);
            },
          ),
        ]),
      ),
    );
  }

  Future<void> pickDob() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (d != null) {
      dob.text =
          '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    }
  }

  Future<void> submit() async {
    if (!_key.currentState!.validate()) return;
    x
      ..name = name.text.trim()
      ..fatherName = father.text.trim()
      ..address = address.text.trim()
      ..city = city.text.trim()
      ..dob = dob.text.trim()
      ..gender = gender
      ..bloodGroup = blood
      ..maritalStatus = marital
      ..education = education.text.trim()
      ..occupation = occupation.text.trim()
      ..mobile = mobile.text.trim()
      ..email = email.text.trim()
      ..notes = notes.text.trim()
      ..photoPath = photo;
    await DB.instance.save(x);
    if (mounted) Navigator.pop(context);
  }

  InputDecoration deco(String text, IconData icon) => InputDecoration(
        labelText: text,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      );

  /// [translate] true hoy to item ni key ne bhasha ma badle (male -> પુરુષ).
  Widget dropdown(String title, IconData icon, String value, List<String> items,
      ValueChanged<String> onChanged,
      {bool translate = true}) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      decoration: deco(title, icon),
      items: items
          .map((e) => DropdownMenuItem(
              value: e, child: Text(translate ? t(e) : e)))
          .toList(),
      onChanged: (v) => onChanged(v ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 14);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.person == null ? t('newForm') : t('editForm'))),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: GestureDetector(
                onTap: photoSheet,
                child: Stack(
                  children: [
                    avatar(photo, 60),
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                          radius: 18, child: Icon(Icons.camera_alt, size: 18)),
                    ),
                  ],
                ),
              ),
            ),
            gap,
            TextFormField(
              controller: name,
              decoration: deco(t('fullName'), Icons.person),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? t('enterName') : null,
            ),
            gap,
            TextFormField(
                controller: father,
                decoration: deco(t('fatherName'), Icons.family_restroom)),
            gap,
            TextFormField(
              controller: address,
              decoration: deco(t('address'), Icons.home),
              maxLines: 3,
            ),
            gap,
            TextFormField(
                controller: city,
                decoration: deco(t('city'), Icons.location_city)),
            gap,
            TextFormField(
              controller: dob,
              readOnly: true,
              decoration: deco(t('dob'), Icons.cake),
              onTap: pickDob,
            ),
            gap,
            dropdown(t('gender'), Icons.wc, gender, genders, (v) => gender = v),
            gap,
            dropdown(t('blood'), Icons.bloodtype, blood, bloods,
                (v) => blood = v,
                translate: false),
            gap,
            dropdown(t('marital'), Icons.favorite, marital, maritals,
                (v) => marital = v),
            gap,
            TextFormField(
                controller: education,
                decoration: deco(t('education'), Icons.school)),
            gap,
            TextFormField(
                controller: occupation,
                decoration: deco(t('occupation'), Icons.work)),
            gap,
            TextFormField(
              controller: mobile,
              keyboardType: TextInputType.phone,
              decoration: deco(t('mobile'), Icons.phone),
            ),
            gap,
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: deco(t('email'), Icons.email),
            ),
            gap,
            TextFormField(
              controller: notes,
              maxLines: 3,
              decoration: deco(t('notes'), Icons.notes),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: submit,
              icon: const Icon(Icons.save),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(t('save')),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
