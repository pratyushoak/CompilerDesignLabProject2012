%{
 #include<stdio.h>
 #include<string.h>
 int keyid=1000,dataid=1004,op=1008,id=1012,numid=1016,para=1020,i=0;
 char output[50][20];
 /*simple word recog*/

%}
DIGIT [0-9]
ID  [a-z|A-Z]
Keyword "Create"|"CREATE"|"create"|"TABLE"|"Table"|"table"|"Alter"|"alter"|"ALTER"|"Drop"|"DROP"|"drop"|" ADD "|" add "|" Add "|"Set"|"set"|"SET"|" FROM "|" From "|" from "|"Where "|"WHERE "|"where "|"DATABASE "|"database "|"Database "|"Modify"|"modify"|"MODIFY"
datatype " integer"|" Integer"|" INTEGER"|" varchar"|" Varchar"|" VARCHAR"|" Float"|" FLOAT"|" float"|" char"|" CHAR"|" Char"|" Long"|" LONG"|" long"
op  [*/+-=]
quotes ["]
%%
\n ECHO;  
{Keyword}  {  printf("%s Keyword %d\n",yytext,keyid);
	      strcpy(output[i++],"key");
	      }
"("      {printf("%s Parenthesis %d\n",yytext,para);strcpy(output[i++],"ob");}
")"      {printf("%s Parenthesis %d\n",yytext,para);strcpy(output[i++],"cb");}
{datatype} {printf("%s Datatype %d\n",yytext,dataid);strcpy(output[i++],"dtype");}
{DIGIT}+ {printf("%s Number %d\n",yytext,numid);strcpy(output[i++],"num");}
{op}  {printf("%s Operator %d\n",yytext,op);strcpy(output[i++],"op");}
{ID}+  {printf("%s Identifier %d\n",yytext,id);strcpy(output[i++],"id");}
. ;
%%

int finite_automata()
{
int state=0,ip=0,brac=0;
if((strcmp(output[ip],"key")==0)&&ip<i)
{ state=1;
  ip++;
  if((strcmp(output[ip],"key")==0)&&ip<i)
   {
     state=2;
     ip++;
     if((strcmp(output[ip],"id")==0)&&ip<i)
     {
       state=3;
       ip++;
       if(ip==i)
       return state;
       else
       state=-3;
       if((strcmp(output[ip],"ob")==0)&&ip<i)
       {
        state=4;
	ip++;
	brac++;
        Q4:if((strcmp(output[ip],"id")==0)&&ip<i)
	    {
              state=5;
	      ip++;
	      if((strcmp(output[ip],"dtype")==0)&&ip<i)
	      {
	      state=6;
	      ip++;
	      
	      if((strcmp(output[ip],"op")==0)&&ip<i)
	      {
	      ip++;
	      goto Q4;
	      }
	      
	      if((strcmp(output[ip],"cb")==0)&&ip<i)
	      {
	      state=7;
	      return state;
	      }
	     
	      else if((strcmp(output[ip],"ob")==0)&&ip<i)
                {
		state=8;
		ip++;
                brac++;
		if((strcmp(output[ip],"num")==0)&&ip<i)
		{
		state=9;
		ip++;
		if((strcmp(output[ip],"cb")==0)&&ip<i)
                 {
		 state=10;
		 ip++;
		 brac--;
		 
		 if((strcmp(output[ip],"op")==0)&&ip<i)
                  {
		  ip++;
		  goto Q4;
		  }
		 if((strcmp(output[ip],"cb")==0)&&ip<i)
                 {
		 state=7;
		 return  state;
		 }
		 
		 }
		}

		}

	      }
	    }
        
       }
      
      
      if((strcmp(output[ip],"key")==0)&&ip<i)
      {
      ip++;
      state=11;
       if((strcmp(output[ip],"key")==0)&&ip<i)
       {
       state=14;
       ip++;
       if((strcmp(output[ip],"id")==0)&&ip<i)
       {
       state=15;
       return state;
       }
       }
      Q11:
      state=11;
      
         if((strcmp(output[ip],"id")==0)&&ip<i)
          {
	  state=12;
	  ip++;
	    if((strcmp(output[ip],"dtype")==0)&&ip<i)
	    {
	    state=13;
	    ip++;
            if((strcmp(output[ip],"op")==0)&&ip<i)
	    {
	    ip++;
	    goto Q11;
	    }
	    
	    }
	  }
      }
      
      
      }
    } 
}
if(brac==0)
return state;
else 
return -1;
}

int main()
{
int j,state,bracket=0;
yylex();
printf("String is converted to : \n");
for(j=0;j<i;j++)
{printf("%s ",output[j]);
}
printf("\n\n");
state=finite_automata();
if(state==3|state==7|state==13|state==15)
printf("\nInput accepted.\n");
else if(state==-1)
printf("\nInput rejected.Unmatched paranthesis.\n");
else
printf("\nInput rejected.Invalid SQL syntax.\n");
return 0;
}
