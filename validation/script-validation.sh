RED='\033[0;31m';
GREEN='\033[0;32m';
NC='\033[0m';
recommencer="true";

while [ $recommencer = true ]
do
    read -p "Commencer le programme ? tappe 1 pour OUI / 2 pour NON  " go;

    if [ $go -eq 1 ]
    then 
        #Installation de vagrant sur la machine + vérification préalable de son existance 
        if [ -d ".vagrant" ]
        then
            echo -e "
    ${GREEN}*********************************************************************${NC}
    Le programme est déjà installer, on passe à la suite
    ${GREEN}*********************************************************************${NC}";
        echo "vagrant déjà installé" > error.log;
        else
            sudo apt-get install vagrant;
            echo -e "
    *********************************************
    ${GREEN}Vagrant est installé !${NC}
    *********************************************";
        fi
        
        #Installation de VirtualBox
        if [ -d ".virtualbox" ]
        then
            echo -e "
    ${GREEN}*********************************************************************${NC}
    Le programme est déjà installer, on passe à la suite
    ${GREEN}*********************************************************************${NC}";
        echo "virtualbox déjà installé" > error.log;
        else
            sudo apt-get install vagrant;
            echo -e "
    *********************************************
    ${GREEN}VirtualBox est installé !${NC}
    *********************************************";
        fi
        
        #On lance vagrant
        vagrant init;    

        #Création du vagrantbox
        read -p "
    *********************************************
    Quelle box voulez-vous installer sur vagrant ?
    Tappe 1 pour xenial64
    Tappe 2 pour trusty64
    *********************************************
        " box;
        #test le user input
        if [ $box -eq 1 ]
        then
            #Remplacement de box dans le vagrant par xenial64
            echo -e "
    ${GREEN}*********************************************${NC}
    Tu as choisi xenial64
    ${GREEN}*********************************************${NC}";
            box="ubuntu\/xenial64";
            sed -i -e "s/config.vm.box = \"base\"/config.vm.box = \"$box\"/g" Vagrantfile;
        elif [ $box -eq 2 ]
        then
            #Remplacement de box dans le vagrant par trusty64
            echo -e "
    ${GREEN}*********************************************${NC}
    Tu as choisi trusty64
    ${GREEN}*********************************************${NC}";
            box="ubuntu\/trusty64";
            sed -i -e "s/config.vm.box = \"base\"/config.vm.box = \"$box\"/g" Vagrantfile;
        else
            echo "Erreur dans le choix de la box non reconnue" > error.log;
            echo -e "${RED}Il faut tapper 1 ou 2 pour choisir la box.${NC} 
Relance le programme !";
            break;
        fi
        #config suplémentaire du vagrant
        # config.vm.network "private_network", ip: "192.168.33.10"
        sed -i -e "s=# config.vm.network \"private_network\", ip: \"192.168.33.10\"=config.vm.network \"private_network\", ip: \"192.168.33.10\"=g" Vagrantfile; 
        
        #Initialisation et config du dossier et du chemin
        dossier="data";
        chemin="/var/www/html";
        read -p "
    *********************************************
    Renseigne ici le dossier racine 
    Par défaut celui-ci sera data
    *********************************************
    " dossier;
        read -p "
    *********************************************
    Renseigne ici le dossier racine 
    Par défaut celui-ci sera /var/www/html
    ATTENTION le chemin doit commencer par /
    *********************************************
    " chemin;  
        # config.vm.synced_folder "../data", "/vagrant_data"
        sed -i -e "s=# config.vm.synced_folder \"..\/data\", \"\/vagrant_data\"=config.vm.synced_folder \"$dossier\", \"$chemin\"=g" Vagrantfile;
        #Création du dossier racine
        mkdir $dossier;
        
        #lancement du vagrant
        echo -e "
    *********************************************
    ${GREEN}Je lance vagrant !${NC}
    *********************************************";
        vagrant up;
        #Affiche les vagrants
        echo -e "
    ${GREEN}*********************************************${NC}
    Voici l'état des vagrant en cours :
    ${GREEN}*********************************************${NC}";
        vagrant global-status;

        #Proposer d'agir sur le vagrant en cours
        read -p "
    *********************************************
    Que veux-tu faire maintenant ? 
    Tappe 1 pour éteindre le vagrant et quitter le programme
    Tappe 2 pour continuer sans interagir
    Tappe 3 pour passer en SSH
    *********************************************
        " whatNow;
        #test user input
        if [ $whatNow -eq 1 ]
        then
            #on éteind
            vagrant halt;
            echo -e "
    *********************************************
    ${GREEN}Vagrant est maintenant éteind, bonne journée !${NC}
    *********************************************";
        elif [ $whatNow -eq 2 ]
        then    
            #on garde allumé
            echo -e "
    *********************************************
    ${GREEN}Vagrant est toujours allumé...${NC}
    *********************************************";
        elif [ $whatNow -eq 3 ]
        then
            #on passe en SSH
            echo -e "
    *********************************************
    ${GREEN}Tu passes en mode SSH !${N}
    *********************************************";
            vagrant ssh;
        else
            echo -e "${RED}ATTENTION !${NC}
Tu as le choix entre 1, 2 ou 3 ! Relance le programme";
            echo "Erreur dans le choix des interactions avec le vagrant" > error.log;
        fi

    elif [ $go -eq 2 ]
    then
        echo -e "
    ******************************************************************************************
    ${GREEN}Vous avez choisi de ne pas lancer ce programme, bonne journée quand même !${NC}
    ******************************************************************************************";
    else
        echo -e "${RED}!! ATTENTION !!${NC}
    Tu dois tapper 1 ou 2, sinon ça marche pas. Relance le programme 
    Je sais ça pique :) ";
        echo "Erreur saisie pour entrer dans le programme" > error.log;
    fi
    read -p "Voulez-vous recommencer le programme ?
Tappe 1 pour OUI
Tappe 2 pour NON
" recommencer;
    if [ $recommencer -eq 1 ]
    then
        echo "Allez on y retourne !";
        recommencer="true";
    elif [ $recommencer -eq 2 ]
    then
        echo "A bientôt !";
        recommencer="false";
    else
        echo "Bon tu dois être fatigué, on va dire qu'on ne recommence pas ;) ";
        echo "Erreur : l'utilisateur ne sait pas s'il veut recommencer ou arrêter" > error.log;
        recommencer="false";
    fi    
done
