git init
>git 저장소 시작

git config --global user.name "<username>"

git config --global user.email
>사용자 이름 및 이메일 설정 (GitHub 닉네임 및 이메일 우선)

git add <filename>

git add .
>변경된 사항 추가, .은 전체 변경 사항 한 번에 추가

git commit -m '<message>'
>변경된 사항 저장, '내용'으로 어떤 점이 변경되었는지 기록 가능

git remote add origin <URL>
<!-- 현재 git은 remote add origin 할 필요 없음 > clone 해왔기 때문 -->
>원격 저장소(repository-repo)에 저장


git push origin main
>변경된 사항을 repo로 이동시키는 데에 활용

git status
> git 상태 확인

git clone <URL>
>repo에서 git을 가져오는 데에 활용