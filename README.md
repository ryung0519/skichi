# 👶 Phone Guardian – A Character-Based Safety App for Children

This project is designed to give parents peace of mind by helping children use smartphones more safely and consciously. It combines step detection and light sensing to manage smartphone usage, especially during walking and nighttime scenarios.

## 📱 Features

### 1. 🚶‍♂️ Step Detection + Character Overlay  
- When the phone is **turned on** and **steps are detected**,  
  → A character appears at the top of the screen  
  → This encourages the user to **look away from the screen while walking**  

### 2. 🌙 Low Light Detection + Screen Lock  
- When the environment light is **below a certain threshold**,  
  → The phone **automatically locks**  
  → This is designed to **limit phone use before bedtime**

### 3. 📞 Emergency Use Exception  
- During walking, if there's an **unavoidable reason** (e.g. incoming call),  
  → Only the character is displayed, allowing the phone to be used temporarily

## ⚙️ Tech Stack

- **Programming Language**: Java
- **Framework**: Flutter
- **IDE**: Android Studio
- **Platform**: Android

## 🧪 Testing & Compatibility

This app is **intended for demonstration and testing purposes** only.  
Due to changes in Android's security model, **the app may not work on devices with security patches newer than 2017**.

✅ Recommended testing environment:
- Android phones with OS and security updates **prior to 2017**
- Physical devices are preferred over emulators for sensor testing (step and light)

## 📂 Project Structure

- `/android`: Native Android code in Java  
- `/lib`: Flutter frontend code  
- `/assets`: Character images and resources  
- `/services`: Step detector and light sensor logic  

## 📌 Disclaimer

> This app is a **prototype for educational/demo purposes**.  
> It is not intended for production use and may not comply with modern Android permission or security requirements.

## 💡 Future Improvements (Planned or Suggested)

- Support for newer Android security models  
- Custom character selection and positioning  
- Night mode scheduling  
- Better power management  

## 🧑‍💻 Authors

- Developed by: [Your Name or Team Name]  
- Contact: [Your Email or GitHub Profile Link]

---

Feel free to contribute, fork, or customize this project!

