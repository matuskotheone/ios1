#!/bin/sh

export LC_NUMERIC=en_US.UTF-8
export POSIXLY_CORRECT=yes



print_help()
{
    echo "neviem este co"
}


AFTERTIME="0000-00-00"
BEFORETIME="9999-99-99" 
COMMAND=""
FILE=""
FILE_BZ2=""
FILE_GZ=""
GENDER=""
WIDTH=""

while [[ "$#" -gt 0 ]]; do 
    case "$1" in
    -a)
        AFTERTIME="$2"
        shift
        shift
        ;;
    -b)
        BEFORETIME="$2"
        shift
        shift
        ;;
    -s)
        if ! [[ "$2" =~ ^[0-9]+$ ]]
        then
            WIDTH="0"
            shift
        else 
            WIDTH="$2"
            shift
            shift
        fi
        ;;
    -g)
        GENDER="$2"
        shift
        shift
        ;;
    -h)
        print_help
        shift
        ;;
    infected)
        COMMAND="$1"
        shift
        ;;
    age)
        COMMAND="$1"
        shift
        ;;
    merge)
        COMMAND="$1"
        shift
        ;;
    gender)
        COMMAND="$1"
        shift
        ;;
    monthly)
        COMMAND="$1"
        shift
        ;;
    yearly)
        COMMAND="$1"
        shift
        ;;
    daily)
        COMMAND="$1"
        shift
        ;;
    districts)
        COMMAND="$1"
        shift
        ;;
    regions)
        COMMAND="$1"
        shift
        ;;
    *)  
        if [[ "$1" == *.bz2 ]]
        then
            FILE_BZ2="$1 $FILE_BZ2"
        elif [[ "$1" == *.gz ]]
        then
            FILE_GZ="$1 $FILE_GZ"
        else
            FILE="$1 $FILE"
        fi
        shift
        ;;
    esac
done

READ_FILES=$(cat $FILE) 

FILTERED=$(echo "$READ_FILES" | \
    awk \
    -F "," \
    -v aftertime="$AFTERTIME"\
    -v beforetime="$BEFORETIME"\
    -v gender="$GENDER"\
    '{
        if ((gender == "" || gender == $4) && ($2 > aftertime && $2 < beforetime))
        {
            print $0
        }
    }')

if [[ $COMMAND == "infected" ]]
then
    out=$(echo "$FILTERED" | awk '{print}END {print NR}')
    echo "$out"
fi

if [[ $COMMAND == "gender" ]]
then
    out=$(echo "$FILTERED" | \
        awk \
        -F "," \
        '{
            if ($4 == "M")
                men+=1
        } END {
            printf("M: %d \nZ: %d", men, (NR-men))
        }')
    echo "$out"
fi



if [[ $COMMAND == "age" ]]
then
    out=$(echo "$FILTERED" | \
        awk \
        -F "," \
        -v width="$WIDTH" \
        '{
            if ($3 <= 5)
            {
                count5 += 1
                next
            }
            else if ($3 <= 15)
            {
                count15 += 1
                next
            }
            else if ($3 <= 25)
            {
                count25 += 1
                next
            }
            else if ($3 <= 35)
            {
                count35 += 1
                next
            }
            else if ($3 <= 45)
            {
                count45 += 1
                next
            }
            else if ($3 <= 55)
            {
                count55 += 1
                next
            }
            else if ($3 <= 65)
            {
                count65 += 1
                next
            }
            else if ($3 <= 75)
            {
                count75 += 1
                next
            }
            else if ($3 <= 85)
            {
                count85 += 1
                next
            }
            else if ($3 <= 95)
            {
                count95 += 1
                next
            }
            else if ($3 <= 105)
            {
                count105 += 1
                next
            }
            else 
            {
                countel += 1
            }
            }
            END { 
            if (width == 0)
            {
                width = 10000
            }
            if (width == "")
            {
                printf("0-5   :%d\n", count5)
                printf("6-15  :%d\n", count15)
                printf("16-25 :%d\n", count25)
                printf("26-35 :%d\n", count35)
                printf("36-45 :%d\n", count45)
                printf("46-55 :%d\n", count55)
                printf("56-65 :%d\n", count65)
                printf("66-75 :%d\n", count75)
                printf("76-85 :%d\n", count85)
                printf("86-95 :%d\n", count95)
                printf("96-105:%d\n", count105)
                printf(">105  :%d\n", countel)
            }
            else 
            {
                printf("0-5   :")
                for (i = 0; i < (count5/width); i++) 
                    printf("#")
                printf("\n6-15  :")  
                for (i = 0; i < (count15/width); i++) 
                    printf("#")
                printf("\n16-25 :")  
                for (i = 0; i < (count25/width); i++) 
                    printf("#")
                printf("\n26-35 :")  
                for (i = 0; i < (count35/width); i++) 
                    printf("#")
                printf("\n36-45 :") 
                for (i = 0; i < (count45/width); i++) 
                    printf("#")
                printf("\n46-55 :")    
                for (i = 0; i < (count55/width); i++) 
                    printf("#")
                printf("\n56-65 :")    
                for (i = 0; i < (count65/width); i++) 
                    printf("#")
                printf("\n66-75 :")    
                for (i = 0; i < (count75/width); i++) 
                    printf("#")
                printf("\n76-85 :")    
                for (i = 0; i < (count85/width); i++) 
                    printf("#")
                printf("\n86-95 :")    
                for (i = 0; i < (count95/width); i++) 
                    printf("#")
                printf("\n96-105:")     
                for (i = 0; i < (count105/width); i++) 
                    printf("#")
                printf("\n>105  :")    
                for (i = 0; i < (countel/width); i++) 
                    printf("#")

                }
        }')
    echo "$out"
fi



if [[ $COMMAND == "daily" ]]
then
    out=$(echo "$FILTERED" | sort -t "," -k 2,2 | \
        awk \
        -F "," \
        -v width="$WIDTH" \
        'BEGIN {
            curr = ""
            currSum = 0
            if (width == 0)
            {
                width = 500
            }
        } {
            if (width == "")
            {
                if (curr == "")
                {
                    curr = $2
                    currSum = 1
                    next
                }
                else if (curr != $2)
                {
                    printf("%s: %d\n", curr, currSum)
                    curr = $2
                    currSum = 1
                }
                else 
                {
                    currSum++
                }
            }
            else
            {
                if (curr == "")
                {
                    curr = $2
                    currSum = 1
                    next
                }
                else if (curr != $2)
                {
                    printf("%s: ", curr)
                    for (i = 0; i < (currSum/width); i++)
                    {
                        printf("#")
                    }
                    printf("\n")
                    curr = $2
                    currSum = 1
                }
                else 
                {
                    currSum++
                }

            }
        } END {
            printf("%s: ", curr)
            for (i = 0; i < (currSum/width); i++)
            {
                printf("#")
            }
            printf("\n")
        }')
    echo "$out"
fi



if [[ $COMMAND == "monthly" ]]
then
    out=$(echo "$FILTERED" | sort -t "," -k 2,2 | \
        awk \
        -F "," \
        -v width="$WIDTH" \
        'BEGIN {
            curr = ""
            currSum = 0
            if (width == 0)
            {
                width = 10000
            }
        } {
            if (width == "")
            {
                if (curr == "")
                {
                    curr = substr($2, 1, length($2)-3)
                    currSum = 1
                    next
                }
                else if (curr != substr($2, 1, length($2)-3))
                {
                    printf("%s: %d\n", curr, currSum)
                    curr = substr($2, 1, length($2)-3)
                    currSum = 1
                }
                else 
                {
                    currSum++
                }
            }
            else
            {
                if (curr == "")
                {
                    curr = substr($2, 1, length($2)-3)
                    currSum = 1
                    next
                }
                else if (curr != substr($2, 1, length($2)-3))
                {
                    printf("%s: ", curr)
                    for (i = 0; i < (currSum/width); i++)
                    {
                        printf("#")
                    }
                    printf("\n")
                    curr = substr($2, 1, length($2)-3)
                    currSum = 1
                }
                else 
                {
                    currSum++
                }

            }
        } END {
            if (width == "")
            {
                printf("%s: %d", curr, currSum)
            }
            else 
            {
                printf("%s: ", curr)
                for (i = 0; i < (currSum/width); i++)
                {
                    printf("#")
                }
                printf("\n")

            }
        }')
    echo "$out"
fi


if [[ $COMMAND == "yearly" ]]
then
    out=$(echo "$FILTERED" | sort -t "," -k 2,2 | \
        awk \
        -F "," \
        -v width="$WIDTH" \
        'BEGIN {
            curr = ""
            currSum = 0
            if (width == 0)
            {
                width = 500
            }
        } {
            if (width == "")
            {
                if (curr == "")
                {
                    curr = substr($2, 1, length($2)-6)
                    currSum = 1
                    next
                }
                else if (curr != substr($2, 1, length($2)-6))
                {
                    printf("%s: %d\n", curr, currSum)
                    curr = substr($2, 1, length($2)-6)
                    currSum = 1
                }
                else 
                {
                    currSum++
                }
            }
            else
            {
                if (curr == "")
                {
                    curr = substr($2, 1, length($2)-6)
                    currSum = 1
                    next
                }
                else if (curr != substr($2, 1, length($2)-6))
                {
                    printf("%s: ", curr)
                    for (i = 0; i < (currSum/width); i++)
                    {
                        printf("#")
                    }
                    printf("\n")
                    curr = substr($2, 1, length($2)-6)
                    currSum = 1
                }
                else 
                {
                    currSum++
                }

            }
        } END {
            if (width == "")
            {
                printf("%s: %d", curr, currSum)
            }
            else 
            {
                printf("%s: ", curr)
                for (i = 0; i < (currSum/width); i++)
                {
                    printf("#")
                }
                printf("\n")

            }
        }')
    echo "$out"
fi





