import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../Core/Constants/assets.dart';
import '../../Core/Constants/colors.dart';
import '../../Core/widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController? emailController;
  late TextEditingController? passwordController;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  StateMachineController? stateMachineController;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;

  SMIInput<bool>? trigSuccess;

  SMIInput<bool>? trigFail;
  SMIInput<bool>? isHandsUp;

  @override
  void initState() {
    emailController = TextEditingController();

    passwordController = TextEditingController();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    emailFocusNode.addListener(() {
      //
      isChecking!.change(emailFocusNode.hasFocus);
    });
    passwordFocusNode.addListener(() {
      //
      isHandsUp!.change(passwordFocusNode.hasFocus);
    });

    super.initState();
  }

  @override
  void dispose() {
    // dispose the text controllers
    emailController?.dispose();
    passwordController?.dispose();

    // dispose also the focus node
    emailFocusNode.removeListener(() {
      isChecking!.change(emailFocusNode.hasFocus);
    });
    passwordFocusNode.removeListener(() {
      isHandsUp!.change(passwordFocusNode.hasFocus);
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.kGrey,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              // welcome text like
              _welcomeText(),
              //the animation :),
              _teddyAnimation(context),

              // form holder Container
              _formHolderContainer(size),
              // Register or signup
              _register(size)
            ],
          ),
        ),
      ),
    );
  }

  Column _register(Size size) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          width: size.width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Dont have an account? "),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: MyColors.kPrimary),
              onPressed: () {},
              child: const Text("Register",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ]),
        ),
      ],
    );
  }

  Container _formHolderContainer(Size size) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(children: [
        // email text field , lets use custom textfield for all :))))
        _emailField(),
        // password field
        _passwordField(),
        // forgot password
        _forgotPassword(),
        // submit login button
        _loginButton(size),
        // google signin method
        _googleSigninMethod()
      ]),
    );
  }

  Column _googleSigninMethod() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {},
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 40, child: Image.asset(Assets.googleIcon)),
            const SizedBox(width: 5),
            const Text("Continue with Google",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ))
          ]),
        ),
      ],
    );
  }

  SizedBox _loginButton(Size size) {
    // put the constant email and password here , to check if the teddy can get sad :( or happy :)

    String mockEmail = 'yegetanaty03@gmail.com';
    String mockPassword = '12345678';
    return SizedBox(
      width: size.width,
      height: 64,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.kPrimary,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (emailController?.text.trim() != mockEmail ||
                passwordController?.text.trim() != mockPassword) {
              trigFail?.change(true);
              return;
            }
            // the email and password here is supposed to be correct
            trigSuccess?.change(true);
          },
          child: const Text("Login",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
    );
  }

  TextButton _forgotPassword() {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: MyColors.kPrimary),
      onPressed: () {},
      child: const Text("Forgot Password ? "),
    );
  }

  Column _passwordField() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        MyCustomTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          obsecureText: true,
          onChanged: (value) {},
          hintText: "Password",
          icon: Icons.password,
        ),
      ],
    );
  }

  MyCustomTextField _emailField() {
    return MyCustomTextField(
      controller: emailController,
      focusNode: emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        numLook?.change(double.parse(value.length.toString()) * 2);
      },
      hintText: "Email Address",
      icon: Icons.email,
    );
  }

  _welcomeText() {
    return const Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text("Hey Welcome Back",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black)),
        ),
      ],
    );
  }

  _teddyAnimation(BuildContext context) {
    return SizedBox(
        height: 300,
        width: 300,
        child: RiveAnimation.asset(
          Assets.tedyAnimation,
          fit: BoxFit.fitHeight,
          stateMachines: const ["Login Machine"],
          onInit: (artboard) {
            stateMachineController =
                StateMachineController.fromArtboard(artboard, "Login Machine");

            artboard.addController(stateMachineController!);
            // inputs
            numLook = stateMachineController!.findInput('numLook');
            isHandsUp = stateMachineController!.findInput('isHandsUp');
            trigSuccess = stateMachineController!.findInput('trigSuccess');
            trigFail = stateMachineController!.findInput('trigFail');

            isChecking = stateMachineController!.findInput('isChecking');
          },
        ));
  }
}
