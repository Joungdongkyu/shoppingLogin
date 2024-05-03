
Git Workflow
git clone [저장소 이름]
cd [저장소 이름]
git checkout develop
git checkout -b feature/[이슈번호]
git status
git add [작업한 파일]
git commit (Commit Convention 항목 참고)
git push origin feature/[이슈번호]
Pull Request 생성 (gh도 사용해보세요!)
Code Review
Merge (Conflict 발생 시 대응 전략 항목 참고)
git checkout develop
git pull origin develop → 주의!! 새로운 브랜치 생성 시 반드시 진행할 것
3번 항목부터 반복

Commit Convention
feat: 새로운 기능 추가
# fix: 버그 수정
# docs: 문서 수정
# style: 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우
# refactor: 코드 리펙토링
# test: 테스트 코드, 리펙토링 테스트 코드 추가
# chore: 빌드 업무 수정, 패키지 매니저 수정


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
