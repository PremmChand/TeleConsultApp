# TeleConsult Basic App (Doctor + Kiosk)

## Overview
Mini telemedicine app (Doctor mobile + Kiosk tablet) with:
- Mocked doctor login
- Incoming call simulation (popup)
- Shared video call screen (ZegoCloud prebuilt UI; replace keys to use real)
- After-call prescription form -> PDF generation -> mock WhatsApp share
- Queue simulation for kiosk

## How to run
1. flutter pub get
2. Doctor app:
   flutter run -t lib/main_doctor.dart
3. Kiosk app:
   flutter run -t lib/main_kiosk.dart

## Notes
- Replace Zego credentials in `lib/constants/app_constants.dart` to test real calls.
- PDF files are saved to app documents directory.
- WhatsApp sharing uses url_launcher (opens browser or WhatsApp app).

## Screenshots

## Patient Screens

![Patient Form](assets/images/patient_form.png)
![Patient Home](assets/images/patient_home.png)
![Patient Prescription](assets/images/patient_prescription.png)
![Patient Video](assets/images/patient_video.png)

## Doctor Screens

![Doctor Login](assets/images/doctor_login.png)
![Doctor Home](assets/images/doctor_home.png)
![Doctor Prescription](assets/images/doctor_prescription.png)
![Doctor Video](assets/images/doctor_video.png)

## Popup Screen

![Popup Screen](assets/images/popup_screen.png)
