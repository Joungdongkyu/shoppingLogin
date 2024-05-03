
Git Workflow
1. git clone [저장소 이름]
2. cd [저장소 이름]
3. git checkout develop
4. git checkout -b feature/[이슈번호]
5. git status
6. git add [작업한 파일]
7. git commit (Commit Convention 항목 참고)
8. git push origin feature/[이슈번호]
9. Pull Request 생성


Commit Convention
1. feat: 새로운 기능 추가
2. fix: 버그 수정
3. docs: 문서 수정
4. style: 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우
5. refactor: 코드 리펙토링
6. test: 테스트 코드, 리펙토링 테스트 코드 추가
7. chore: 빌드 업무 수정, 패키지 매니저 수정


현재까지 구현한것
1. 카카오 소셜 로그인
2. 회원가입 여부에 따라 페이지 바뀌기
3. 로그아웃 회원탈퇴 기능
4. 결제 환경설정
5. 상품 리스트 클릭 시 상세 페이지 이동

구현하지 못한것
1. 상품을 유저 디폴트로 관리
2. 결제 관련 포인트와 쿠폰
3. 장바구니에서 결제까지의 기능
