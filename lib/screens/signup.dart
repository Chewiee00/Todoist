import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstnameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController birthdateController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    String formattedDate;
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    final firstname = TextFormField(
      controller: firstnameController,
      validator: validateFirstName,
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
    );
    final username = TextFormField(
      controller: usernameController,
      validator: validateUsername,
      decoration: const InputDecoration(
        hintText: "Username",
      ),
    );

    final birthdate = TextFormField(
      onTap: () async {
        DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(1900),
            lastDate: DateTime.now());
        if (newDate == null) {
          birthdateController.text = '';
          return;
        }
        formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

        birthdateController.text = formattedDate;
      },
      controller: birthdateController,
      validator: validateBirthdate,
      decoration: const InputDecoration(
        hintText: 'Birthdate',
      ),
    );

    final location = TextFormField(
      controller: locationController,
      validator: validateLocation,
      decoration: const InputDecoration(
        hintText: "Location",
      ),
    );

    final lastname = TextFormField(
      controller: lastnameController,
      validator: validateLastName,
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
    );

    final email = TextFormField(
      controller: emailController,
      validator: validateEmail,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      validator: validatePassword,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
    );

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_key.currentState!.validate()) {
            context.read<AuthProvider>().signUp(
                firstnameController.text,
                lastnameController.text,
                usernameController.text,
                birthdateController.text,
                locationController.text,
                emailController.text,
                passwordController.text);
            setState(() {});
            Navigator.pop(context);
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _key,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              firstname,
              lastname,
              username,
              birthdate,
              location,
              email,
              password,
              SignupButton,
              backButton
            ],
          ),
        ),
      ),
    );
  }
}
//https://learnflutterwithme.com/firebase-auth-validation

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'E-mail address is required.';
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';
  return null;
}

String? validateFirstName(String? formfirstname) {
  if (formfirstname == null || formfirstname.isEmpty)
    return 'First Name is required.';

  return null;
}

String? validateLastName(String? formlastname) {
  if (formlastname == null || formlastname.isEmpty)
    return 'Last Name is required.';

  return null;
}

String? validateUsername(String? formusername) {
  if (formusername == null || formusername.isEmpty)
    return 'Username is required.';

  return null;
}

String? validateLocation(String? formlocation) {
  if (formlocation == null || formlocation.isEmpty)
    return 'Location is required.';

  return null;
}

String? validateBirthdate(String? formBirthdate) {
  final now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  if (formBirthdate == null || formBirthdate.isEmpty) {
    return 'Birthdate is required.';
  }
  if (formBirthdate == formattedDate) {
    return 'Enter a valid Birthdate';
  }

  return null;
}

String? validatePassword(String? formpassword) {
  if (formpassword == null || formpassword.isEmpty)
    return 'Password is required.';
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formpassword))
    return '''
      Password must be at least 6 characters,
      include an uppercase letter, number and symbol.
      ''';

  return null;
}
