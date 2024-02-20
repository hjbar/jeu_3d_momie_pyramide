state gameState;

public enum state {
  InLab, OutLab, InTpEntree, InTpExit, EnterPyr, ExitPyr, OnTpExit, OnTpEntree
}

void updateState(state s){
  /** met à jour l'etat du jeu en fonction du parametre passe en argument
    s : state
  **/
  gameState = s;
  if (gameState == state.InTpEntree || gameState == state.InTpExit){
    transition_timer = transition_sec * fps;  
  }
}
