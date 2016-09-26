!Copyright 2016,  Hiori Kino
!
!Licensed under the Apache License, Version 2.0 (the "License");
!you may not use this file except in compliance with the License.
!You may obtain a copy of the License at
!
!    http://www.apache.org/licenses/LICENSE-2.0
!
!Unless required by applicable law or agreed to in writing, software
!distributed under the License is distributed on an "AS IS" BASIS,
!WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!See the License for the specific language governing permissions and
!limitations under the License.


program test
implicit none
call main
stop 
contains
subroutine main
implicit none
integer:: nf=10
integer::ios

      CHARACTER*5 SCHNAM
      CHARACTER*10 HMNAME
      INTEGER:: JB(2,3)
integer:: NO,IL,NG,K,JA,I,J,iall,ingmax

open(nf,file='GENERTOR',action='read',status='unknown',iostat=ios)
if (ios/=0)then
 write(6,*)'failed to open a file'; stop 
endif
 write(6,*)'subroutine gen_init'
 write(6,*)'use m_gen'
 iall=0
 ingmax=0
  100 FORMAT(I3,1X,I2,I2,1X,A5,1X,A10)
     do 
     READ(NF,100,iostat=ios) NO,IL,NG,SCHNAM,HMNAME
     if (ios/=0) exit 
     if (no==0) exit
     iall=iall+1
     write(6,'(a,3(I3,1H,),a,1H,,a,a)')'call gen%addspg(', NO,IL,NG,"'"//(SCHNAM)//"'","'"//(HMNAME)//"'",')'
       ingmax=max(ingmax,ng)
            DO  K=1,NG
               READ(NF,200) JA,((JB(I,J),I=1,2),J=1,3)
  200          FORMAT(I2,6I2)
		write(6, &
'(a,I3,2H,[, 2(1H[I3,1H,I3,2H],),1H[,I3,1H,I3,2H]],a)') &
'call gen%addgen(',  JA,((JB(I,J),I=1,2),J=1,3),')'
	    enddo
     enddo

 write(6,*)'end subroutine gen_init'
 close(nf)
  write(6,*)'! total ',iall,', ngmax=',ingmax

end subroutine main
end program test

