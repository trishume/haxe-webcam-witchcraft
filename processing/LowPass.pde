class LowPass {
    ArrayList buffer;
    int len;
    float output;

    LowPass(int len) {
        this.len = len;
        buffer = new ArrayList(len);
        for(int i = 0; i < len; i++) {
            buffer.add(new Float(0.0));
        }
    }

    void input(float v) {
        buffer.add(new Float(v));
        buffer.remove(0);

        float sum = 0;
        for(int i=0; i<buffer.size(); i++) {
                Float fv = (Float)buffer.get(i);
                sum += fv.floatValue();
        }
        output = sum / buffer.size();
    }
}
