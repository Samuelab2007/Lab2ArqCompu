public class ToBinario {
    int indice;

    public void setIndice(int indice) {
        this.indice = indice;
    }

    public ToBinario(int indice) {
        this.indice = indice;
    }

    String toBinary(){
        StringBuilder binario = new StringBuilder();
        for (int i = 7; i >= 0; i--) {
            // esta operación sirve para obtener el valor del bit en la posicion i
            // desplazando el bit mas significativo a la posicion del bit menos significativo
            // la operacion & 1 permite aislar el bit en la posicion i para obtener solo ese valor.
            int bit = (indice >> i) & 1;
            binario.append(bit);
        }
        return binario.toString();
    }
}
