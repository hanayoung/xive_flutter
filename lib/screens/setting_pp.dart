import 'package:flutter/material.dart';
import 'package:xive/widgets/paragraph.dart';
import 'package:xive/widgets/setting_divider.dart';
import 'package:xive/widgets/title_bar.dart';

class SettingPp extends StatelessWidget {
  const SettingPp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TitleBar(
                title: "개인정보 처리 방침",
                // func: pop(),
              ),
              Paragraph(
                title: '1. 개인정보 처리방침',
                content:
                    '개인정보 처리방침은 ‘XIVE(카이브)’의 특정 가입 절차를 거친 이용자들이 이용 가능한 서비스를 제공함에 있어, 개인정보를 어떻게 수집·이용·보관·파기하는지에 대한 정보를 담은 방침을 의미합니다. ‘XIVE(카이브)’는 개인정보 처리방침에 따라 개인정보보호법 등 국내 개인정보 보호 법령은 모두 준수하고 있음을 알려드립니다.',
              ),
              SettingDivider(),
              Paragraph(
                title: '2. 커뮤니티 가이드라인',
                content:
                    '‘XIVE(카이브)’은 더 나은 서비스 제공을 위해 다음 항목 중 최소한의 개인정보를 수집합니다.\n\n1) 회원가입 시 수집되는 개인정보(필수)\n회원 이름, 회원 닉네임, 이메일 계정, 비밀번호(해독이 불가능하도록 암호화하여 저장), 서비스 버전, OS, OS 버전, 디바이스 모델명, 단말 고유 ID(‘회사’가 ‘회원’의 단말에 무작위로 부여하는 ID), Time Zone\n이 외에도 ‘회사’는 서비스 이용과정에서 서비스 이용기록, 접속 로그, 쿠키, 접속 IP 정보, 아이디 등이 자동으로 생성된 정보를 수집할 수 있습니다.',
              ),
              SettingDivider(),
              Paragraph(
                title: '3. 수집한 개인정보의 처리 목적',
                content:
                    '수집된 개인정보는 다음의 목적에 한하여 활용됩니다.\n\n1. 가입 및 탈퇴 의사 확인, 회원 식별\n2. 서비스 제공 및 기존·신규 시스템 개발·유지·개선\n3. 불법·약관 위반 게시물 게시 등 부정행위 방지를 위한 운영 시스템 개발·유지·개선\n4. 문의·제휴·광고·이벤트·게시 관련 요청 응대 및 처리\n5. 서비스 제공 및 고도화',
              ),
              SettingDivider(),
              Paragraph(
                title: '4. 개인정보의 제3자 제공',
                content:
                    '‘XIVE(카이브)’은 회원의 개인정보를 제3자에게 제공하지 않습니다. 단, 다음의 사유가 있을 경우 제공할 수 있습니다.\n\n1. 이용자의 생명이나 안전에 급박한 위험이 확인되어 이를 해소하기 위한 경우\n2. 관련법에 따른 규정에 의한 경우\n3. 관리자의 경우(가입자 식별을 위해)\n4. 서비스 악성 활용, 스팸 유저의 식별 및 처리의 경우\n5. ‘서비스 이용 약관’ 위반의 경우',
              ),
              SettingDivider(),
              Paragraph(
                title: '5. 수집한 개인정보의 보관 및 파기',
                content:
                    '‘XIVE(카이브)’는 서비스를 제공하는 동안 개인정보 처리방침 및 관련법에 의거하여 회원의 개인정보를 지속적으로 관리 및 보관합니다. 탈퇴 등 개인정보 수집 및 이용목적이 달성될 경우, 수집된 개인정보는 즉시 또는 다음과 같이 일정 기간 이후 파기됩니다.\n\n1. 가입시 수집된 개인정보: 탈퇴 후 30일\n2. 기기 정보 및 로그 기록: 최대 1년\n3. 삭제된 콘텐츠 기록: 삭제 후 30일',
              ),
              SettingDivider(),
              Paragraph(
                title: '6. 정보주체의 권리, 의무 및 행사',
                content:
                    '회원은 언제든지 서비스 내부 ‘마이페이지’에서 자신의 개인정보를 조회하거나 수정, 삭제, 탈퇴를 할 수 있습니다.',
              ),
              SettingDivider(),
              Paragraph(
                title: '7. 쿠키',
                content:
                    '쿠키란 웹사이트를 운영하는 데 이용되는 서버가 귀하의 브라우저에 보내는 아주 작은 텍스트 파일로서 귀하의 컴퓨터 및 모바일 기기에 저장됩니다. 서비스는 사이트 로그인을 위해 아이디 식별에 쿠키를 사용할 수 있습니다.',
              ),
              SettingDivider(),
              Paragraph(
                title: '8. 개인정보에 관한 책임자 및 서비스',
                content:
                    '‘XIVE(카이브)’는 회원의 개인정보를 최선으로 보호하고 관련된 불만을 처리하기 위해 노력하고 있습니다. 관련 문의사항은 책임자(이형기, dlgudrl1203@gmail.com )를 통해 전달해주시기 바랍니다.',
              ),
              SettingDivider(),
              Paragraph(
                title: '9. 기타',
                content: '이 개인정보 처리방침은 2024년 04월 10일에 최종적으로 개정되었습니다.',
              ),
              SizedBox(
                height: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
