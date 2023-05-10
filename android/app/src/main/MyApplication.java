import androidx.multidex.MultiDexApplication;

public class MyApplication extends MultiDexApplication {
    @Override
    public String toString() {
        return "MyApplication []";
    }

    @Override
    public void onCreate() {
        super.onCreate();
        // 如果您有其他的初始化代码，也可以在这里添加
    }
}
